#import "HomeTweetsCDTVC.h"
#import "Tweet+create.h"
#import "ThreadManager.h"
#import "ApiUtil.h"

@interface HomeTweetsCDTVC()<FHSTwitterEngineAccessTokenDelegate>
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
    [ApiUtil fetchLatestTweets];
    [self.refreshControl endRefreshing];
}

- (void) fetchOldTweets
{
    [ApiUtil fethOldTweets];
}

@end