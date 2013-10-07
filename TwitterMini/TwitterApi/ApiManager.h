//
//  ApiManager.h
//  TwitterMini
//
//  Created by nikhil.ji on 03/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ApiManager : NSObject

+ (ApiManager *) sharedInstance;

- (void)postTweet:(NSString *)tweetString onSuccess:(onSuccessBlock)success onFailure:(onErrorBlock)failure;

- (void)getHomeTimelineAfterID:(NSString *)afterId count:(int)count onSuccess:(onSuccessBlock)success onFailure:(onErrorBlock)failure;
- (void)getHomeTimelineSinceID:(NSString *)sinceID count:(int)count onSuccess:(onSuccessBlock)success onFailure:(onErrorBlock)failure;
- (void)listFollowersForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (onSuccessBlock) success onFailure:(onErrorBlock)failure;
- (void)listFriendsForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (onSuccessBlock) success onFailure:(onErrorBlock)failure;
- (void)fetchTimelineForUser:(NSString *)user count:(int)count sinceID:(NSString *)sinceID maxID:(NSString *)maxID onSuccess: (onSuccessBlock) success;
- (void) fetchProfileAndOnSuccess: (onSuccessBlock) success onFailure:(onErrorBlock)failure;

@end

@interface NSString (ApiManager)
+ (NSString *)generateUUID;
@end

