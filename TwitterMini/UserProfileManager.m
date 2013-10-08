
#import "UserProfileManager.h"
#import "ThreadManager.h"
#import "ApiInterface.h"
#import "UserObject.h"

static User *owner = nil;

@implementation UserProfileManager

+ (void) fetchOwnerProfileWithSuccessHandler: (successBlock) postFetch
{
    if(owner) {
        postFetch(owner);
        return;
    }
    [self fetchFromCoreDataAndOnSuccess: postFetch onFailure: ^{
        [self fetchOwnerAndOnFetch: postFetch];
    }];
}

+ (void) fetchOwnerAndOnFetch: (successBlock) postFetch
{
    [[ApiInterface sharedInstance] fetchOwnerProfileWithSuccessHandler:^(UserObject *userObject) {
        NSManagedObjectContext *writerContext = [[ThreadManager sharedInstance] coreDataWriterInterface];
        [writerContext performBlock:^{
            User *fetchedUser = [User UserWithObject:userObject inManagedObjectContext:writerContext];
            fetchedUser.isOwner = YES;
            [writerContext save:nil];
            [[ThreadManager sharedInstance] saveChangesWrtContext: writerContext];
            owner = fetchedUser;
            postFetch(owner);
        }];
    } failHandler:^(NSError *error) {
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
