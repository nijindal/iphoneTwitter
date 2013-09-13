//
//  CoreDataTableViewController.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"

@interface CoreDataTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;

- (void) performFetch;

@end
