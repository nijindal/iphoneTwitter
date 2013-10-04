//
//  Util.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface ApiUtil : NSObject

+ (NSDictionary *) changeTweetDataToCorrectType: (NSDictionary *) rawData;

+ (NSArray *) changeTweetsArray: (NSArray *) rawData;

+ (void) fetchLatestTweetsWithResponseHandler: (void (^) (void)) handler;

+ (void) fethOldTweetsWithResponseHandler: (void (^) (void)) handler;

@end
