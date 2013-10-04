//
//  UserProfileManager.h
//  TwitterMini
//
//  Created by nikhil.ji on 25/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+Create.h"

typedef void (^successBlock) (User *owner);
@interface UserProfileManager : NSObject
+ (void) fetchOwnerProfileWithSuccessHandler: (successBlock) postFetch;
@end
