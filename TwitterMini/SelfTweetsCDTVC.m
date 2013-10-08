#import "SelfTweetsCDTVC.h"
#import "Tweet+create.h"
#import "ThreadManager.h"
#import "ApiInterface.h"
#import "TweetObject.h"

@interface SelfTweetsCDTVC()
@property (nonatomic, strong) NSManagedObjectContext *mainMoc;
@end

@implementation SelfTweetsCDTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    if(!self.mainMoc){
        self.mainMoc = [[ThreadManager sharedInstance] createInMemoryStoreContext];
        [self fetchNewTweets];
    }
}

- (void) setupFetchController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: self.mainMoc sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchNewTweets
{
    dispatch_async(GCDBackgroundThread, ^{
        [[ApiInterface sharedInstance] fetchTimelineForUser:self.designatedUser.handle count:25 sinceID:nil maxID:nil onSuccess: ^(NSArray *tweetsArray){
            [self.mainMoc performBlock:^{
                for (TweetObject *tweetObject in  tweetsArray) {
                    [Tweet tweetWithObject: tweetObject inManagedObjectContext: self.mainMoc];
                    [[ThreadManager sharedInstance] saveChangesWrtContext: self.mainMoc];
                }
            }];
        }];
    });
}

@end
