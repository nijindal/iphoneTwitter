
#import "CoreDataTableViewController.h"
#import "FHSTwitterEngine.h"
#import "ApiUtil.h"
#import "ThreadManager.h"

@interface TweetsCDTVC : CoreDataTableViewController<FHSTwitterEngineAccessTokenDelegate>

- (void) fetchData;
- (void) setupFetchController;
- (void) fetchOldTweets;

@end
