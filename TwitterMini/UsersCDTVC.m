#import "UsersCDTVC.h"
#import "ProfileTVC.h"

@implementation UsersCDTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    if(!self.mainMoc){
        self.mainMoc = [[ThreadManager sharedInstance] createInMemoryStoreContext];
        [self fetchData];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    User *user = [self.fetchResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.handle;
    [cell.imageView setImage:[UIImage imageWithData:user.image_data]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    User *user = [self.fetchResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    ProfileTVC *dvc = (ProfileTVC*) segue.destinationViewController;
    [dvc initWithUser:user];
}

- (void) loadData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO selector:@selector(compare:)]];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: self.mainMoc sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchData {
    dispatch_async(GCDBackgroundThread, ^{
        id requestData;
        if([self.tableType isEqualToString: @"Followers"]) {
            requestData = [[FHSTwitterEngine sharedEngine] listFollowersForUser:self.designatedUser.handle isID:NO withCursor:@"-1"];
        } else {
            requestData = [[FHSTwitterEngine sharedEngine] listFriendsForUser:self.designatedUser.handle isID:NO withCursor:@"-1"];
        }
        NSArray *usersData = [requestData valueForKey:@"users"];
        NSManagedObjectContext *tmpWritercontext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        tmpWritercontext.parentContext = self.mainMoc;
        for(NSDictionary *userData in usersData) {
            [tmpWritercontext performBlockAndWait:^{
                [User UserWithData: userData inManagedObjectContext: tmpWritercontext];
            }];
        }
    });
}

@end
