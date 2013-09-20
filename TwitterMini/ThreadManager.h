//
//  ThreadManager.h
//  TwitterMini
//
//  Created by nikhil.ji on 18/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface ThreadManager : NSObject

// These are for the dispatch_async() calls that you use to get around the synchronous-ness
#define GCDBackgroundThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDMainThread dispatch_get_main_queue()

+ (NSManagedObjectContext *) CoreDateWriterContext;
+ (NSManagedObjectContext *) mainThreadContext;

@end
