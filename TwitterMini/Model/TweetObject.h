//
//  Tweet.h
//  TwitterMini
//
//  Created by nikhil.ji on 07/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObject.h"

@interface TweetObject : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) UserObject *tweetedBy;

- (TweetObject*) initWithApiData: (NSDictionary *) tweetData;

@end
