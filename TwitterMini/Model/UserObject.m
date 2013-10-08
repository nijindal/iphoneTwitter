//
//  User.m
//  TwitterMini
//
//  Created by nikhil.ji on 07/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

- (UserObject *) initWithApiData: (NSDictionary *) userData
{
    self =  [self init];
    self.name = [[userData valueForKey:@"name"] description];
    self.handle = [[userData valueForKey:@"screen_name"] description];
    self.desc = [[userData valueForKey:@"description"] description];
    self.image_url = [[userData valueForKey:@"profile_image_url"] description];
    self.followers_count = [userData valueForKey:@"followers_count"];
    self.friends_count = [userData valueForKey:@"friends_count"];
    self.banner_url = [[userData valueForKey:@"profile_banner_url"] description];
    self.tweet_count = [userData valueForKey:@"statuses_count"];
    self.id = [userData valueForKey:@"id"];
    return self;
}

- (NSDictionary *) toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:
                                       @[self.name, self.handle, self.desc, self.image_url, self.followers_count, self.friends_count, self.banner_url, self.tweet_count, self.id]  forKeys:
                                       @[@"name", @"handle", @"desc", @"image_url", @"followers_count", @"friends_count", @"banner_url", @"tweet_count", @"id"]];
    return dictionary;
}

@end
