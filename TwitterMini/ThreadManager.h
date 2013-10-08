
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface ThreadManager : NSObject

#define GCDBackgroundThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDLowPrioityQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define GCDMainThread dispatch_get_main_queue()

@property (nonatomic, strong) NSManagedObjectContext *coreDataWriterInterface;
@property (nonatomic, strong) NSManagedObjectContext *mainThreadContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

+ (ThreadManager *) sharedInstance;
- (void) saveChangesWrtContext: (NSManagedObjectContext *) context;
- (NSManagedObjectContext *) CoreDateReaderInterface;
- (NSManagedObjectContext*) createInMemoryStoreContext;

@end
