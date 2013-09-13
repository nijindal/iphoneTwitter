#import "Tweet+create.h"
#import "User+Create.h"

@implementation Tweet (create)

+ (Tweet*) tweetWithData: (NSDictionary *)data inManagedObjectContext: (NSManagedObjectContext *) context
{
    Tweet *tweet = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@", [data valueForKey:@"id"]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //handle error.
    } else if (![matches count]) {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
        tweet.text = [[data valueForKey:@"text"] description];
        tweet.time = [data valueForKey:@"created_at"];
        tweet.id = [data valueForKey:@"id"];
        NSDictionary *userData = [data valueForKey:@"user"];
        tweet.tweetedBy = [User UserWithData:userData inManagedObjectContext:context];
        [context save:nil];
    } else {
        tweet = [matches lastObject];
    }
    return tweet;
}

@end
