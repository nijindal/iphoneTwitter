//
//  User.h
//  TwitterMini
//
//  Created by nikhil.ji on 08/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * banner_url;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * followers_count;
@property (nonatomic, retain) NSNumber * friends_count;
@property (nonatomic, retain) NSString * handle;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSData * image_data;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic) BOOL isOwner;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * tweet_count;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *tweets;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addFriendsObject:(User *)value;
- (void)removeFriendsObject:(User *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
