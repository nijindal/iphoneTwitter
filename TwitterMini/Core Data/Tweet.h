//
//  Tweet.h
//  TwitterMini
//
//  Created by nikhil.ji on 08/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) User *tweetedBy;

@end
