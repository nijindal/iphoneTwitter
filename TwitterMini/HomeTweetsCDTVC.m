#import "HomeTweetsCDTVC.h"
#import "Tweet+create.h"
#import "ThreadManager.h"
#import "ApiUtil.h"
#import "ApiManager.h"

@interface HomeTweetsCDTVC()<FHSTwitterEngineAccessTokenDelegate>
@property (nonatomic) BOOL hasRequestedOldTweets;
@end

@implementation HomeTweetsCDTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}

- (void) setupFetchController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: [[ThreadManager sharedInstance] mainThreadContext] sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchData
{
    dispatch_async(GCDBackgroundThread, ^{
        [ApiUtil fetchLatestTweetsWithResponseHandler:^{
            dispatch_async(GCDMainThread, ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

- (void) fetchOldTweets
{
    if(!self.hasRequestedOldTweets) {
        dispatch_async(GCDBackgroundThread, ^{
            self.hasRequestedOldTweets = YES;
            [ApiUtil fethOldTweetsWithResponseHandler: ^{
                self.hasRequestedOldTweets = NO;
            }];
        });
    }
}

@end