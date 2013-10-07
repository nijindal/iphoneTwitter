//
//  ApiInterface.h
//  TwitterMini
//
//  Created by nikhil.ji on 07/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetObject.h"
#import "Constants.h"

@interface ApiInterface : NSObject

typedef void (^tweetsFetchSuccess) (NSArray *tweetsArray);
typedef void (^usersFetchSuccess) (NSArray *usersArray);

+ (ApiInterface *) sharedInstance;
- (void)fetchTimelineForUser:(NSString *)user count:(int)count sinceID:(NSString *)sinceID maxID:(NSString *)maxID onSuccess: (tweetsFetchSuccess) success;
- (void) fetchLatestTweetsWithResponseHandler: (tweetsFetchSuccess) handler;
- (void) fetchOldTweetsWithResponseHandler: (tweetsFetchSuccess) handler;
- (void)listFollowersForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (usersFetchSuccess) success onFailure:(onErrorBlock)failure;
- (void)listFriendsForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (usersFetchSuccess) success onFailure:(onErrorBlock)failure;
@end
