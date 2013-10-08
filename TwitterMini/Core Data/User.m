//
//  User.m
//  TwitterMini
//
//  Created by nikhil.ji on 08/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "User.h"
#import "Tweet.h"
#import "User.h"


@implementation User

@dynamic banner_url;
@dynamic desc;
@dynamic followers_count;
@dynamic friends_count;
@dynamic handle;
@dynamic id;
@dynamic image_data;
@dynamic image_url;
@dynamic isOwner;
@dynamic name;
@dynamic tweet_count;
@dynamic timestamp;
@dynamic followers;
@dynamic friends;
@dynamic tweets;

- (void) willSave
{
    [super willSave];
    for (Tweet *tweet in self.tweets) {
        if(![tweet.timestamp isEqualToDate: self.timestamp]){
            tweet.timestamp = self.timestamp;
        }
    }
}

@end
