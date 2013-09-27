
#import "UserProfileManager.h"
#import "ThreadManager.h"
#import "FHSTwitterEngine.h"

static User *owner = nil;

@implementation UserProfileManager

+ (User *) ownerProfile
{
    if(owner) {
        return owner;
    }
    [self fetchFromCoreData];
    if(owner) {
        return owner;
    }
    [self fetchAndUpdateOwner];
    return owner;
}

+ (void) fetchAndUpdateOwner
{
    id profile = [[FHSTwitterEngine sharedEngine] verifyCredentials];
    [[[ThreadManager sharedInstance] coreDataWriterInterface] performBlockAndWait:^{
        User *fetchedUser = [User UserWithData:profile inManagedObjectContext:[[ThreadManager sharedInstance] coreDataWriterInterface]];
        fetchedUser.isOwner = YES;
        [fetchedUser.managedObjectContext save:nil];
        [[ThreadManager sharedInstance] writeChangeToCoreData];
       owner = fetchedUser;
    }];
}

+ (void) fetchFromCoreData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSManagedObjectContext *reader = [[ThreadManager sharedInstance] CoreDateReaderInterface];
    request.predicate = [NSPredicate predicateWithFormat:@"isOwner == YES"];
    __block NSError *error = nil;
    
    [reader performBlockAndWait:^{
        NSArray *matches = [reader executeFetchRequest:request error:&error];
        if (matches && ([matches count] == 1)) {
            owner = [matches lastObject];
        }
    }];
}


@end
