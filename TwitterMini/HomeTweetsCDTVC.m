#import "HomeTweetsCDTVC.h"
#import "Tweet+create.h"

@implementation HomeTweetsCDTVC

-(void) setContext: (NSManagedObjectContext *) context
{
    [super setContext:context];
    if(context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO selector:@selector(compare:)]];
        self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    }
}

- (void) refetchTweets {
    [self.tweetsFetcher fetchHomeTimelineForUser:@"j1nd4L" withHandler:^(NSArray *response) {
        for (NSDictionary *tweet in  response) {
            [Tweet tweetWithData:tweet inManagedObjectContext:self.context];
        }
        [super refetchTweets];
    }];
}

@end