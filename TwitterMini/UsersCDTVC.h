//
//  FollowersCDTVC.h
//  TwitterMini
//
//  Created by nikhil.ji on 24/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+Create.h"
#import "ThreadManager.h"
#import "UserProfileManager.h"

@interface UsersCDTVC : CoreDataTableViewController

@property (nonatomic, strong) User *designatedUser;
@property (nonatomic, strong) NSManagedObjectContext *mainMoc;
@property (nonatomic, strong) NSString *tableType;
@end
