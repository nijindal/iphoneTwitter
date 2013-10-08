#import "HomeTweetsCDTVC.h"
#import "Tweet+create.h"
#import "ThreadManager.h"
#import "ApiInterface.h"

@interface HomeTweetsCDTVC()
@property (nonatomic) BOOL hasRequestedOldTweets;
@end

@implementation HomeTweetsCDTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self fetchNewTweets];
}

- (void) setupFetchController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: [[ThreadManager sharedInstance] mainThreadContext] sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchNewTweets
{
    dispatch_async(GCDBackgroundThread, ^{
        [[ApiInterface sharedInstance] fetchLatestTweetsWithResponseHandler:^(NSArray *tweetsArray) {
            dispatch_async(GCDMainThread, ^{
                [self.refreshControl endRefreshing];
            });
            [self saveTweetsToCoreData: tweetsArray];
        }];
    });
}

- (void) saveTweetsToCoreData : (NSArray *) tweetsArray
{
    NSManagedObjectContext *writerContext = [[ThreadManager sharedInstance] coreDataWriterInterface];
    for (TweetObject *tweetObject in  tweetsArray) {
        [writerContext performBlock:^{
            [Tweet tweetWithObject:tweetObject inManagedObjectContext: writerContext];
            [[ThreadManager sharedInstance] writeChangeToCoreData];
        }];
    }
}

- (void) fetchOldTweets
{
    if(!self.hasRequestedOldTweets) {
        dispatch_async(GCDBackgroundThread, ^{
            self.hasRequestedOldTweets = YES;
            [[ApiInterface sharedInstance] fetchOldTweetsWithResponseHandler:^(NSArray *tweetsArray) {
                self.hasRequestedOldTweets = NO;
                [self saveTweetsToCoreData:tweetsArray];
            }];
        });
    }
}

@end