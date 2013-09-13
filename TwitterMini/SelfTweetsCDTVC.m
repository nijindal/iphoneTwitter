#import "SelfTweetsCDTVC.h"
#import "Tweet+create.h"
#import "User.h"

@implementation SelfTweetsCDTVC

-(void) setContext: (NSManagedObjectContext *) context
{
    [super setContext:context];
    if(context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"tweetedBy.handle == %@", @"j1nd4L"];
        self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    }
}

- (void) refetchTweets {
    [self.tweetsFetcher fetchSelfTimelineForUser:@"j1nd4L" withHandler:^(NSArray *response) {
        for (NSDictionary *tweet in  response) {
            [Tweet tweetWithData:tweet inManagedObjectContext:self.context];
        }
        [super refetchTweets];
    }];
}


@end
