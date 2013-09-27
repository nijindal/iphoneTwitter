//
//  ProfileTVC.h
//  TwitterMini
//
//  Created by nikhil.ji on 24/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileTVC : UITableViewController

- (void) initWithUser: (User*) user;

@end
