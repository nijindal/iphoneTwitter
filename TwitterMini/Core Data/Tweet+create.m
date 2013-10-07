#import "Tweet+create.h"
#import "User+Create.h"

@implementation Tweet (create)

+ (Tweet*) tweetWithObject: (TweetObject *)object inManagedObjectContext: (NSManagedObjectContext *) context
{
    Tweet *tweet = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@", tweet.id];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //handle error.
    } else if (![matches count]) {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
        tweet.text = object.text;
        tweet.time = object.time;
        tweet.id = object.id;
        tweet.tweetedBy = [User UserWithObject:object.tweetedBy inManagedObjectContext:context];
        [context save:nil];
    } else {
        tweet = [matches lastObject];
    }
    return tweet;    
}

@end
