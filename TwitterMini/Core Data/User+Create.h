//
//  User+Create.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "User.h"

@interface User (Create)

+ (User *) UserWithData: (NSDictionary *)data inManagedObjectContext: (NSManagedObjectContext *) context;

@end
