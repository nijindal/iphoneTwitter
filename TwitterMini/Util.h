//
//  Util.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSDictionary *) changeTweetDataToCorrectType: (NSDictionary *) rawData;

+ (NSArray *) changeTweetsArray: (NSArray *) rawData;
@end
