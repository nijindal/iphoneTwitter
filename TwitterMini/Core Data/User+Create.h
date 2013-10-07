//
//  User+Create.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "User.h"
#import "UserObject.h"

@interface User (Create)

+ (User *) UserWithObject: (UserObject *)data inManagedObjectContext: (NSManagedObjectContext *) context;

@end
