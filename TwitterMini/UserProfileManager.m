
#import "UserProfileManager.h"
#import "ThreadManager.h"
#import "ApiManager.h"

static User *owner = nil;

@implementation UserProfileManager

+ (void) fetchOwnerProfileWithSuccessHandler: (successBlock) postFetch
{
    if(owner) {
        postFetch(owner);
        return;
    }
    //TODO: Find a better pattern to handle this case. async will make it ever more dirty..
    [self fetchFromCoreDataAndOnSuccess: postFetch onFailure: ^{
        [self fetchOwnerAndOnFetch: postFetch];
    }];
    
}

+ (void) fetchOwnerAndOnFetch: (successBlock) postFetch
{
    [[ApiManager sharedInstance] fetchProfileAndOnSuccess:^(id profile) {
        [[[ThreadManager sharedInstance] coreDataWriterInterface] performBlock:^{
            User *fetchedUser = [User UserWithData:profile inManagedObjectContext:[[ThreadManager sharedInstance] coreDataWriterInterface]];
            fetchedUser.isOwner = YES;
            [fetchedUser.managedObjectContext save:nil];
            [[ThreadManager sharedInstance] writeChangeToCoreData];
            owner = fetchedUser;
            postFetch(owner);
        }];
    } onFailure:^(NSError *error) {
        NSLog(@"Error occured: %@", error);
    }];
}

+ (void) fetchFromCoreDataAndOnSuccess: (successBlock) postFetch onFailure: (void (^) (void)) failHandler
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSManagedObjectContext *reader = [[ThreadManager sharedInstance] CoreDateReaderInterface];
    request.predicate = [NSPredicate predicateWithFormat:@"isOwner == YES"];
    __block NSError *error = nil;
    
    [reader performBlock:^{
        NSArray *matches = [reader executeFetchRequest:request error:&error];
        if (matches && ([matches count] == 1)) {
            owner = [matches lastObject];
            postFetch(owner);
        } else {
            failHandler();
        }
    }];
}


@end
