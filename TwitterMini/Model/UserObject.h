//
//  User.h
//  TwitterMini
//
//  Created by nikhil.ji on 07/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic, strong) NSString *banner_url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *image_data;

@property (nonatomic, strong) NSNumber *followers_count;
@property (nonatomic, strong) NSNumber *friends_count;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *tweet_count;
@property (nonatomic) BOOL isOwner;

- (UserObject *) initWithApiData: (NSDictionary *) userData;

@end
