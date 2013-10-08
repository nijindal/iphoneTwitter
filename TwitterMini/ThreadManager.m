#import "ThreadManager.h"

@interface ThreadManager()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;;
@property (nonatomic, strong) NSManagedObjectContext *coreDateWriterContext;
@end

static ThreadManager *sharedInstance = nil;

@implementation ThreadManager

+ (ThreadManager *) sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

- (NSManagedObjectContext *)createInMemoryStoreContext
{
    NSManagedObjectContext *tempMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    tempMoc.persistentStoreCoordinator = coordinator;
    return tempMoc;
}

- (NSManagedObjectContext *) coreDateWriterContext
{
    if(_coreDateWriterContext) {
        return _coreDateWriterContext;
    }
    _coreDateWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [_coreDateWriterContext setPersistentStoreCoordinator: self.persistentStoreCoordinator];
    return _coreDateWriterContext;
}

- (NSManagedObjectContext *) coreDataWriterInterface
{
    if(_coreDataWriterInterface) return _coreDataWriterInterface;
    _coreDataWriterInterface = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    _coreDataWriterInterface.parentContext = self.mainThreadContext;
    return _coreDataWriterInterface;
}

- (void) saveChangesWrtContext: (NSManagedObjectContext *) context
{
    if(!context) return;
    [context performBlock: ^{
        NSError *error = nil;
        [context save :&error];
        if(error){
            NSLog(@"Error occured while saving....");
            return;
        }
        [self saveChangesWrtContext: context.parentContext];
    }];
}

- (NSManagedObjectContext *) CoreDateReaderInterface
{
    NSManagedObjectContext *tmpContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    tmpContext.parentContext = self.mainThreadContext;
    return tmpContext;
}

- (NSManagedObjectContext *) mainThreadContext
{
    if(_mainThreadContext) return _mainThreadContext;
    _mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainThreadContext.parentContext = self.coreDateWriterContext;
    return _mainThreadContext;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tweets.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TweetsAppDelegate" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
