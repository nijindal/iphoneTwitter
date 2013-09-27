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

+ (User *) UserWithData: (NSDictionary *)data inManagedObjectContext: (NSManagedObjectContext *) context
{
    User *user = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@", [data valueForKey:@"id"]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        //handle error.
    } else if (![matches count]) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = [[data valueForKey:@"name"] description];
        user.handle = [[data valueForKey:@"screen_name"] description];
        user.desc = [[data valueForKey:@"description"] description];
        user.image_url = [[data valueForKey:@"profile_image_url"] description];
        user.followers_count = [data valueForKey:@"followers_count"] ;
        user.friends_count = [data valueForKey:@"friends_count"];
        user.banner_url = [[data valueForKey:@"profile_banner_url"] description];
        user.tweet_count = [data valueForKey:@"statuses_count"];
        user.id = [data valueForKey:@"id"];
        user.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString: user.image_url]];
        [context save:nil];
    } else {
        user = [matches lastObject];
    }
    return user;
}

@end
