#import "CoreDataTableViewController.h"
#import "ThreadManager.h"

@interface TweetsCDTVC : CoreDataTableViewController

- (void) setupFetchController;
- (void) fetchOldTweets;

@end
