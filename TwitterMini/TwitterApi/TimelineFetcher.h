//
//  TimelineFetcher.h
//  TwitterMini
//
//  Created by nikhil.ji on 07/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineFetcher : NSObject

typedef void(^responseHandler)(NSArray *response);

- (id) init;
- (void) fetchHomeTimelineForUser : (NSString *)username withHandler : (responseHandler) handler;
- (void) fetchSelfTimelineForUser:(NSString *)username withHandler:(responseHandler)handler;

@end
