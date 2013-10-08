//
//  User+Create.m
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "User+Create.h"
#import "UserProfileManager.h"
#import "ThreadManager.h"

@implementation User (Create)

+ (User *) UserWithObject: (UserObject *)object inManagedObjectContext: (NSManagedObjectContext *) context;
{
    User *user = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@", object.id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        //handle error.
    } else if (![matches count]) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = object.name;
        user.handle = object.handle;
        user.desc = object.desc;
        user.image_url = object.image_url;
        user.followers_count = object.followers_count;
        user.friends_count = object.friends_count;
        user.banner_url = object.banner_url;
        user.tweet_count = object.tweet_count;
        user.id = object.id;
        user.timestamp = [NSDate date];
        dispatch_async(GCDLowPrioityQueue, ^{
            [context performBlock:^{
                user.timestamp = [NSDate date];
                user.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString: user.image_url]];
                [[ThreadManager sharedInstance] saveChangesWrtContext:context];
            }];
        });
    } else {
        user = [matches lastObject];
    }
    return user;
}

@end
