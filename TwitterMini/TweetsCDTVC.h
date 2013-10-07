
#import "CoreDataTableViewController.h"
#import "FHSTwitterEngine.h"
#import "ThreadManager.h"

@interface TweetsCDTVC : CoreDataTableViewController<FHSTwitterEngineAccessTokenDelegate>

- (void) setupFetchController;
- (void) fetchOldTweets;

@end
