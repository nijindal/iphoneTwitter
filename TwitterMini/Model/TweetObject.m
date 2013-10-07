//
//  Tweet.m
//  TwitterMini
//
//  Created by nikhil.ji on 07/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "TweetObject.h"

@implementation TweetObject

//Desginated initializer.
- (TweetObject*) initWithApiData: (NSDictionary *) tweetData
{
    self = [self init];
    self.text = [[tweetData valueForKey:@"text"] description];
    self.time = [self parseTweetTime: [tweetData valueForKey:@"created_at"]];
    self.id = [tweetData valueForKey:@"id"];
    self.tweetedBy = [[UserObject alloc] initWithApiData:[tweetData valueForKey:@"user"]];
    return self;
}

- (NSDate *) parseTweetTime: (NSString *) dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE LLLL d HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

@end