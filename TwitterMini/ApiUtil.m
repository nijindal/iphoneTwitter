#import "ApiUtil.h"
#import "ThreadManager.h"
#import "Tweet+create.h"
#import "ApiManager.h"

static NSString * const LATEST_HOME_TWEET_ID = @"latest_home_tweet_id";
static NSString * const LAST_HOME_TWEET_ID = @"last_home_tweet_id";

@implementation ApiUtil

+ (NSDictionary *) changeTweetDataToCorrectType: (NSDictionary *) rawData;
{
    NSMutableDictionary *oldData = [rawData mutableCopy];
    NSString *dateString = [oldData valueForKey:@"created_at"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE LLLL d HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    [oldData setObject:date forKey:@"created_at"];
    return oldData;
}

+ (NSArray *) changeTweetsArray: (NSArray *) rawData
{
    if(![rawData isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *oldData = [rawData mutableCopy];
    for (int i=0; i<[oldData count]; i++) {
        NSDictionary *tweet = oldData[i];
        oldData[i] = [ApiUtil changeTweetDataToCorrectType:tweet];
    }
    return oldData;
}

+ (void) fetchLatestTweetsWithResponseHandler: (void (^) (void)) handler
{
    NSNumber *latestTweetId = [[NSUserDefaults standardUserDefaults] valueForKey: LATEST_HOME_TWEET_ID];
    NSString *latestIDString = [latestTweetId boolValue] ? [NSString stringWithFormat:@"%lld", [latestTweetId longLongValue]] : nil;
    __block NSNumber *maxValue = [latestTweetId boolValue] ? latestTweetId : [NSNumber numberWithInt:0];
    
    NSNumber *lastTweetId = [[NSUserDefaults standardUserDefaults] valueForKey: LAST_HOME_TWEET_ID];
    __block NSNumber *minValue = [lastTweetId boolValue] ? lastTweetId : nil;
    
    NSLog(@"Max Value: %@, Min Value: %@", maxValue, minValue);
    [[ApiManager sharedInstance] getHomeTimelineSinceID:latestIDString count:25
                                            onSuccess:^(id responseObject) {
                                                handler();
                                                NSManagedObjectContext *writer = [[ThreadManager sharedInstance] coreDataWriterInterface];
                                                responseObject = [ApiUtil changeTweetsArray: responseObject];
                                                
                                                for (NSDictionary *tweet in  responseObject) {
                                                    if([maxValue compare:[tweet valueForKey:@"id"]] == NSOrderedAscending){
                                                        maxValue = [tweet valueForKey:@"id"];
                                                    }
                                                    if (!minValue || [minValue compare:[tweet valueForKey:@"id"]] == NSOrderedDescending) {
                                                        minValue = [tweet valueForKey:@"id"];
                                                    }
                                                    [writer performBlock:^{
                                                        [Tweet tweetWithData:tweet inManagedObjectContext: writer];
                                                        [[ThreadManager sharedInstance] writeChangeToCoreData];
                                                    }];
                                                }
                                                [[NSUserDefaults standardUserDefaults] setValue:maxValue forKey: LATEST_HOME_TWEET_ID];
                                                [[NSUserDefaults standardUserDefaults] setValue:minValue forKey: LAST_HOME_TWEET_ID];
                                            } onFailure:^(NSError *error) {
                                                handler();
                                                NSLog(@"Error occured %@", error);
                                            }];
}

+ (void) fethOldTweetsWithResponseHandler: (void (^) (void)) handler
{
    __block NSNumber *lastTweetId = [[NSUserDefaults standardUserDefaults] valueForKey: LAST_HOME_TWEET_ID];
    if([lastTweetId boolValue]){
        NSLog(@"Min Value: %@", lastTweetId);
        NSString *lastIDString = [NSString stringWithFormat:@"%lld", [lastTweetId longLongValue]];
        [[ApiManager sharedInstance] getHomeTimelineAfterID:lastIDString count:25
                                                onSuccess:^(id responseObject) {
                                                    handler();
                                                    NSManagedObjectContext *writerContext = [[ThreadManager sharedInstance] coreDataWriterInterface];
                                                    responseObject = [ApiUtil changeTweetsArray: responseObject];
                                                    for (NSDictionary *tweet in  responseObject) {
                                                        if ([lastTweetId compare:[tweet valueForKey:@"id"]] == NSOrderedDescending) {
                                                            lastTweetId = [tweet valueForKey:@"id"];
                                                        }
                                                        [writerContext performBlock:^{
                                                            [Tweet tweetWithData:tweet inManagedObjectContext: writerContext];
                                                            [[ThreadManager sharedInstance] writeChangeToCoreData];
                                                        }];
                                                    }
                                                    [[NSUserDefaults standardUserDefaults] setValue:lastTweetId forKey: LAST_HOME_TWEET_ID];
                                                } onFailure:^(NSError *error) {
                                                    handler();
                                                    NSLog(@"Error occured %@", error);
                                                }];
    }
}


@end
