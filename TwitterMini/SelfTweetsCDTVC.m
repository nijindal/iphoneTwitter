#import "SelfTweetsCDTVC.h"
#import "Tweet+create.h"
#import "ThreadManager.h"
#import "ApiManager.h"

@interface SelfTweetsCDTVC()
@property (nonatomic, strong) NSManagedObjectContext *mainMoc;
@end

@implementation SelfTweetsCDTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    if(!self.mainMoc){
        self.mainMoc = [[ThreadManager sharedInstance] createInMemoryStoreContext];
        [self fetchData];
    }
}

- (void) setupFetchController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: self.mainMoc sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchData
{
    dispatch_async(GCDBackgroundThread, ^{
        [[ApiManager sharedInstance] fetchTimelineForUser:self.designatedUser.handle count:25 sinceID:nil maxID:nil onSuccess: ^(id responseObject){
            NSLog(@"response Object %@", responseObject);
            responseObject = [ApiUtil changeTweetsArray: responseObject];
            for (NSDictionary *tweet in  responseObject) {
                [self.mainMoc performBlockAndWait:^{
                    [Tweet tweetWithData:tweet inManagedObjectContext: self.mainMoc];
                }];
            }
        }];
    });
}

@end
