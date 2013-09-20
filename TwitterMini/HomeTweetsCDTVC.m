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
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:@"W7z7KpZNxVxD3UnUHVBdnQ" andSecret:@"EmR8ldrd1mtNSvDcl307LfpMAAdq9Nhqa8acNLI84"];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
    [self checkForNewTweets];
}

- (void) loadTweets {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: [ThreadManager mainThreadContext] sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchData
{
    [ApiUtil fetchLatestTweets];
}

- (void) fetchOldTweets
{
    [ApiUtil fethOldTweets];
}

- (NSString *)loadAccessToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)storeAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}



@end