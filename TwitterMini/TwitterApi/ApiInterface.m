//
//  ApiInterface.m
//  TwitterMini
//
//  Created by nikhil.ji on 07/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "ApiInterface.h"
#import "ApiManager.h"
#import "TweetObject.h"

static NSString * const LATEST_HOME_TWEET_ID = @"latest_home_tweet_id";
static NSString * const LAST_HOME_TWEET_ID = @"last_home_tweet_id";

static ApiInterface *sharedInstance = nil;

@implementation ApiInterface

+ (ApiInterface *) sharedInstance
{
    if(!sharedInstance){
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

- (void)fetchTimelineForUser:(NSString *)user count:(int)count sinceID:(NSString *)sinceID maxID:(NSString *)maxID onSuccess: (tweetsFetchSuccess) success
{
    [[ApiManager sharedInstance] fetchTimelineForUser:user count:count sinceID:sinceID maxID:maxID onSuccess:^(id responseObject) {
        NSArray *tweetsData = (NSArray*) responseObject;
        NSMutableArray *tweetsArray = [[NSMutableArray alloc] initWithCapacity:tweetsData.count];
        for(NSDictionary *tweetData in tweetsData){
            [tweetsArray addObject:[[TweetObject alloc] initWithApiData:tweetData]];
        }
        success(tweetsArray);
    }];
}

- (void) fetchLatestTweetsWithResponseHandler: (tweetsFetchSuccess) handler
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *latestTweetId = [defaults valueForKey: LATEST_HOME_TWEET_ID];
    NSString *latestTweetIdString = [latestTweetId boolValue] ? [latestTweetId stringValue] : nil;
    __block NSNumber *maxValue = [latestTweetId boolValue] ? latestTweetId : nil;
    
    NSNumber *lastTweetId = [[NSUserDefaults standardUserDefaults] valueForKey: LAST_HOME_TWEET_ID];
    __block NSNumber *minValue = [lastTweetId boolValue] ? lastTweetId : nil;
    
    NSLog(@"Max Value: %@, Min Value: %@", maxValue, minValue);
    [[ApiManager sharedInstance] getHomeTimelineSinceID:latestTweetIdString count:25 onSuccess:^(id responseObject) {
        NSArray *tweetsData = (NSArray*) responseObject;
        NSMutableArray *tweetsArray = [[NSMutableArray alloc] initWithCapacity:tweetsData.count];
        for (NSDictionary *tweetData in  responseObject) {
            TweetObject *tweetObject = [[TweetObject alloc] initWithApiData:tweetData];
            [tweetsArray addObject:tweetObject];
            if(!maxValue || [maxValue compare: tweetObject.id] == NSOrderedAscending){
                maxValue = tweetObject.id;
            }
            if (!minValue || [minValue compare: tweetObject.id] == NSOrderedDescending) {
                minValue = tweetObject.id;
            }
        }
        [defaults setValue:maxValue forKey: LATEST_HOME_TWEET_ID];
        [defaults setValue:minValue forKey: LAST_HOME_TWEET_ID];
        handler(tweetsArray);
    } onFailure:^(NSError *error) {
        NSLog(@"Error occured %@", error);
    }];
}

- (void) fetchOldTweetsWithResponseHandler: (tweetsFetchSuccess) handler
{
    __block NSNumber *lastTweetId = [[NSUserDefaults standardUserDefaults] valueForKey: LAST_HOME_TWEET_ID];
    if([lastTweetId boolValue]){
        NSLog(@"Min Value: %@", lastTweetId);
        NSString *lastIDString = [NSString stringWithFormat:@"%lld", [lastTweetId longLongValue]];
        [[ApiManager sharedInstance] getHomeTimelineAfterID:lastIDString count:25 onSuccess:^(id responseObject) {
            NSArray *tweetsData = (NSArray*) responseObject;
            NSMutableArray *tweetsArray = [[NSMutableArray alloc] initWithCapacity:tweetsData.count];
            for (NSDictionary *tweetData in  responseObject) {
                TweetObject *tweetObject = [[TweetObject alloc] initWithApiData:tweetData];
                [tweetsArray addObject:tweetObject];
                if ([lastTweetId compare:tweetObject.id ] == NSOrderedDescending) {
                    lastTweetId = tweetObject.id;
                }
            }
            [[NSUserDefaults standardUserDefaults] setValue:lastTweetId forKey: LAST_HOME_TWEET_ID];
            handler(tweetsArray);
        } onFailure:^(NSError *error) {
            NSLog(@"Error occured %@", error);
        }];
    }
}

- (void)listFollowersForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (usersFetchSuccess) success onFailure:(onErrorBlock)failure
{
    [[ApiManager sharedInstance] listFollowersForUser:user withCursor:cursor onSuccess:^(id responseObject) {
        NSArray *usersArray = [self parseUserFetchData:responseObject];
        success(usersArray);
    } onFailure:failure];
}

- (void)listFriendsForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (usersFetchSuccess) success onFailure:(onErrorBlock)failure
{
    [[ApiManager sharedInstance] listFriendsForUser:user withCursor:cursor onSuccess:^(id responseObject) {
        NSArray *usersArray = [self parseUserFetchData:responseObject];
        success(usersArray);
    } onFailure:failure];
}

- (NSArray *) parseUserFetchData: (id) responseObject
{
    NSDictionary *response = (NSDictionary*) responseObject;
    NSArray *usersData = [response valueForKey:@"users"];
    NSMutableArray *usersArray = [[NSMutableArray alloc] initWithCapacity:usersData.count];
    for(NSDictionary *userData in usersData){
        [usersArray addObject:[[UserObject alloc] initWithApiData:userData]];
    }
    return usersArray;
}


@end
