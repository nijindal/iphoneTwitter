//
//  UserProfileManager.h
//  TwitterMini
//
//  Created by nikhil.ji on 25/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+Create.h"

@interface UserProfileManager : NSObject
+ (User *) ownerProfile;
@end
