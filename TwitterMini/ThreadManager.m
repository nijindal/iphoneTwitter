#import "ThreadManager.h"

@interface ThreadManager()
@end

static NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
static NSManagedObjectModel *managedObjectModel = nil;
static NSManagedObjectContext *coreDateWriterContext = nil ;
static NSManagedObjectContext *mainThreadContext = nil ;
static dispatch_queue_t backgroundQueue = nil;

@implementation ThreadManager

+ (dispatch_queue_t) backgroundQueue
{
    if(backgroundQueue){
        return backgroundQueue;
    }
    backgroundQueue = dispatch_queue_create("CoreDataWriter", DISPATCH_QUEUE_SERIAL);
    return backgroundQueue;
}

+ (NSManagedObjectContext *) CoreDateWriterContext
{
    if(coreDateWriterContext) {
        return coreDateWriterContext;
    }
    dispatch_sync([self backgroundQueue], ^{
        coreDateWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [coreDateWriterContext setPersistentStoreCoordinator:[self getPersistentStoreCoordinator]];
    });
    return coreDateWriterContext;
}

+ (NSManagedObjectContext *) mainThreadContext
{
    if(mainThreadContext) return mainThreadContext;
    mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [mainThreadContext setPersistentStoreCoordinator: [self getPersistentStoreCoordinator]];
    
    return mainThreadContext;
}

+ (NSPersistentStoreCoordinator *) getPersistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tweets.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Error Occured %@", error);
    }
    
    return persistentStoreCoordinator;
}

+ (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TweetsAppDelegate" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}



+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
