#import "UsersCDTVC.h"
#import "ProfileTVC.h"
#import "ApiInterface.h"

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
    UIImage *avatar = [UIImage imageWithData:user.image_data] ?: [UIImage imageNamed:@"default-avatar"];
    [cell.imageView setImage:avatar];
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
        void (^handleResponse) (NSArray *usersArray) = ^(NSArray *usersArray){
            NSManagedObjectContext *tmpWritercontext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            tmpWritercontext.parentContext = self.mainMoc;
            for(UserObject *userObject in usersArray) {
                [tmpWritercontext performBlock:^{
                    [User UserWithObject:userObject inManagedObjectContext:tmpWritercontext];
                }];
            }
        };

        if([self.tableType isEqualToString: @"Followers"]) {
            [self setTitle:@"Followers"];
            [[ApiInterface sharedInstance] listFollowersForUser: self.designatedUser.handle withCursor:@"-1" onSuccess:handleResponse onFailure:^(NSError *error){
                NSLog(@"Error Occured %@", error);
            }];
        } else {
            [self setTitle:@"Following"];
            [[ApiInterface sharedInstance] listFriendsForUser:self.designatedUser.handle withCursor:@"-1" onSuccess:handleResponse onFailure:^(NSError *error){
                NSLog(@"Error Occured %@", error);
            }];
        }
    });
}

@end
