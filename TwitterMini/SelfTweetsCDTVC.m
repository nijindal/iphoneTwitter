#import "SelfTweetsCDTVC.h"
#import "Tweet+create.h"
#import "User.h"
#import "ThreadManager.h"

@implementation SelfTweetsCDTVC

- (void) loadTweets
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"tweetedBy.handle == %@", @"j1nd4L"];
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: [ThreadManager mainThreadContext] sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchData
{
    NSNumber *latestTweetId = [[NSUserDefaults standardUserDefaults] valueForKey:@"latest_self_tweet_id"];
    NSString *stringFormat =  latestTweetId ? [NSString stringWithFormat:@"%lld", [latestTweetId longLongValue]] : nil;
    
    dispatch_async(GCDBackgroundThread, ^{
        NSArray *queryResponse =     [[FHSTwitterEngine sharedEngine] getTimelineForUser:@"j1nd4L" isID:NO count:25 sinceID:stringFormat maxID:nil];
        NSLog(@"Self Response %@", queryResponse);
        queryResponse = [ApiUtil changeTweetsArray: queryResponse];
        NSNumber *maxValue = latestTweetId ? latestTweetId : [NSNumber numberWithInt:0];
        for (NSDictionary *tweet in  queryResponse) {
            if([maxValue compare:[tweet valueForKey:@"id"]] == NSOrderedAscending) {
                maxValue = [tweet valueForKey:@"id"];
            }
            [[ThreadManager CoreDateWriterContext] performBlockAndWait:^{
                [Tweet tweetWithData:tweet inManagedObjectContext:[ThreadManager CoreDateWriterContext]];
            }];
        }
        [[NSUserDefaults standardUserDefaults] setValue:maxValue forKey:@"latest_self_tweet_id"];
    });
}

@end
