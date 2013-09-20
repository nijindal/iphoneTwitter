//
//  Util.m
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "ApiUtil.h"
#import "ThreadManager.h"
#import "FHSTwitterEngine.h"
#import "Tweet+create.h"

#define FAIRLY_HIGH_NUMBER @9999999999999999999LL;

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

+ (void) fetchLatestTweets
{
    NSNumber *latestTweetId = [[NSUserDefaults standardUserDefaults] valueForKey:@"latest_home_tweet_id"];
    NSString *latestIDString = latestTweetId ? [NSString stringWithFormat:@"%lld", [latestTweetId longLongValue]] : nil;
    __block NSNumber *maxValue = latestTweetId ? latestTweetId : [NSNumber numberWithInt:0];
    
    NSNumber *lastTweetId = [[NSUserDefaults standardUserDefaults] valueForKey:@"last_home_tweet_id"];
    __block NSNumber *minValue = lastTweetId ? lastTweetId : FAIRLY_HIGH_NUMBER;
    
    dispatch_async(GCDBackgroundThread, ^{
        NSArray *queryResponse = [[FHSTwitterEngine sharedEngine] getHomeTimelineSinceID:latestIDString count:25];
        NSLog(@"%@", queryResponse);
        queryResponse = [ApiUtil changeTweetsArray: queryResponse];
        
        for (NSDictionary *tweet in  queryResponse) {
            if([maxValue compare:[tweet valueForKey:@"id"]] == NSOrderedAscending){
                maxValue = [tweet valueForKey:@"id"];
            }
            if ([minValue compare:[tweet valueForKey:@"id"]] == NSOrderedDescending) {
                minValue = [tweet valueForKey:@"id"];
            }
            [[ThreadManager CoreDateWriterContext] performBlock:^{
                [Tweet tweetWithData:tweet inManagedObjectContext: [ThreadManager CoreDateWriterContext]];
            }];
        }
        [[NSUserDefaults standardUserDefaults] setValue:maxValue forKey:@"latest_home_tweet_id"];
        [[NSUserDefaults standardUserDefaults] setValue:minValue forKey:@"last_home_tweet_id"];
    });
    
}

+ (void) fethOldTweets
{
    NSNumber *lastTweetId = [[NSUserDefaults standardUserDefaults] valueForKey:@"last_home_tweet_id"];
    NSString *lastIDString = lastTweetId ? [NSString stringWithFormat:@"%lld", [lastTweetId longLongValue]] : nil;
    __block NSNumber *minValue = lastTweetId ? lastTweetId : [NSNumber numberWithInt:0];
    
    dispatch_async(GCDBackgroundThread, ^{
        NSArray *queryResponse = [[FHSTwitterEngine sharedEngine] getHomeTimelineAfterID:lastIDString count:25];
        NSLog(@"%@", queryResponse);
        queryResponse = [ApiUtil changeTweetsArray: queryResponse];
        
        for (NSDictionary *tweet in  queryResponse) {
            if ([minValue compare:[tweet valueForKey:@"id"]] == NSOrderedDescending) {
                minValue = [tweet valueForKey:@"id"];
            }
            [[ThreadManager CoreDateWriterContext] performBlock:^{
                [Tweet tweetWithData:tweet inManagedObjectContext: [ThreadManager CoreDateWriterContext]];
            }];
        }
        [[NSUserDefaults standardUserDefaults] setValue:minValue forKey:@"last_home_tweet_id"];
    });
}


@end
