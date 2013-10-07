//
//  Tweet+create.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "Tweet.h"
#import "TweetObject.h"

@interface Tweet (create)

+ (Tweet*) tweetWithObject: (TweetObject *)data inManagedObjectContext: (NSManagedObjectContext *) context;

@end
