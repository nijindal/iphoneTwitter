//
//  Util.m
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSDictionary *) changeTweetDataToCorrectType: (NSDictionary *) rawData;
{
    NSMutableDictionary *oldData = [rawData mutableCopy];
    NSString *dateString = [oldData valueForKey:@"created_at"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE LLLL d HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    [oldData setObject:date forKey:@"created_at"];
    return oldData;
}

+ (NSArray *) changeTweetsArray: (NSArray *) rawData
{
    NSMutableArray *oldData = [rawData mutableCopy];
    for (int i=0; i<[oldData count]; i++) {
        NSDictionary *tweet = oldData[i];
        oldData[i] = [Util changeTweetDataToCorrectType:tweet];
    }
    return oldData;
}

@end
