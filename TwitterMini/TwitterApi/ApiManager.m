//
//  ApiManager.m
//  TwitterMini
//
//  Created by nikhil.ji on 03/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "ApiManager.h"
#import "FHSTwitterEngine.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLRequestSerialization.h"
#import "ThreadManager.h"

static NSString * const url_statuses_home_timeline = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
static NSString * const url_statuses_user_timeline = @"https://api.twitter.com/1.1/statuses/user_timeline.json";

static NSString * const url_followers_list = @"https://api.twitter.com/1.1/followers/list.json";
static NSString * const url_friends_list = @"https://api.twitter.com/1.1/friends/list.json";

static NSString * const url_account_verify_credentials = @"https://api.twitter.com/1.1/account/verify_credentials.json";

static NSString * const url_statuses_update = @"https://api.twitter.com/1.1/statuses/update.json";

static ApiManager *sharedInstance = nil;

@implementation NSString (ApiManager)

+ (NSString *)generateUUID {
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0f) {
        return [[NSUUID UUID]UUIDString];
    } else {
        CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef string = CFUUIDCreateString(kCFAllocatorDefault, theUUID);
        CFRelease(theUUID);
        NSString *uuid = [NSString stringWithString:(__bridge NSString *)string];
        CFRelease(string);
        return uuid;
    }
}

- (BOOL)fhs_isNumeric {
	const char *raw = (const char *)[self UTF8String];
    
	for (int i = 0; i < strlen(raw); i++) {
		if (raw[i] < '0' || raw[i] > '9') {
            return NO;
        }
	}
	return YES;
}

@end

@implementation ApiManager

+ (ApiManager *) sharedInstance
{
    if(!sharedInstance){
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

- (void)postTweet:(NSString *)tweetString onSuccess:(onSuccessBlock)success onFailure:(onErrorBlock)failure
{
    if(!tweetString.length)
    {
        NSLog(@"Error: Tweet cant be empty.");
        [NSError errorWithDomain:nil code:100 userInfo:@{@"Error": @"Tweet cant be empty."}];
        return;
    }
    [self sendPOSTHttpRequest: url_statuses_update withParams:@{@"status": tweetString} onSuccess:success onfailure:failure];
}

- (void) fetchProfileAndOnSuccess: (onSuccessBlock) success onFailure:(onErrorBlock)failure
{
    [self sendGETHttpRequest:url_account_verify_credentials withParams:nil onSuccess:^(id responseObject) {
        success(responseObject);
    } onfailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)fetchTimelineForUser:(NSString *)user count:(int)count sinceID:(NSString *)sinceID maxID:(NSString *)maxID onSuccess: (onSuccessBlock) success;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(count > 0) {
        params[@"count"] = [NSString stringWithFormat:@"%d",count];
    }
    if(sinceID.length) {
        params[@"since_id"] = sinceID;
    }
    if(maxID.length) {
        params[@"max_id"] = maxID;
    }
    [self sendGETHttpRequest: url_statuses_user_timeline withParams: params onSuccess: success onfailure: nil];
}

- (void)listFollowersForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (onSuccessBlock) success onFailure:(onErrorBlock)failure
{
    NSDictionary *params = @{@"skip_status":@"true", @"include_entities":@"false", @"screen_name":user, @"cursor": cursor};
    [self sendGETHttpRequest:url_followers_list withParams:params onSuccess:success onfailure:nil];
}

- (void)listFriendsForUser:(NSString *)user withCursor:(NSString *)cursor onSuccess: (onSuccessBlock) success onFailure:(onErrorBlock)failure
{
    NSDictionary *params = @{@"skip_status":@"true", @"include_entities":@"false", @"screen_name":user, @"cursor": cursor};
    [self sendGETHttpRequest:url_friends_list withParams:params onSuccess:success onfailure:nil];
}


- (void)getHomeTimelineSinceID:(NSString *)sinceID count:(int)count onSuccess:(onSuccessBlock)success onFailure:(onErrorBlock)failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(sinceID.length) {
        params[@"since_id"] = sinceID;
    }
    if(count) {
        params[@"count"] = [NSString stringWithFormat:@"%d",count];
    }
    
    [self sendGETHttpRequest:url_statuses_home_timeline withParams:params onSuccess:success onfailure:failure];
}


- (void)getHomeTimelineAfterID:(NSString *)afterId count:(int)count onSuccess:(onSuccessBlock)success onFailure:(onErrorBlock)failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(afterId.length) {
        params[@"max_id"] = afterId;
    }
    if(count) {
        params[@"count"] = [NSString stringWithFormat:@"%d",count];
    }
    [self sendGETHttpRequest:url_statuses_home_timeline withParams:params onSuccess:success onfailure:failure];
}


- (void) sendGETHttpRequest: (NSString *) requestString withParams: (NSDictionary *) queryParams onSuccess:(onSuccessBlock)success
                  onfailure:(onErrorBlock)failure

{
    NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:queryParams.count];
    for(id param in queryParams) {
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@", param, queryParams[param]]];
    }
    requestString = queryParams.count ? [NSString stringWithFormat:@"%@?%@", requestString, [paramArray componentsJoinedByString:@"&"]] : requestString;
    NSURL *requestUrl = [[NSURL alloc] initWithString: requestString];
    NSLog(@"Request URL : %@", requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [request setHTTPMethod: @"GET"];
    [request setHTTPShouldHandleCookies:NO];
    [[FHSTwitterEngine sharedEngine] signRequest:request];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Received: %@", responseObject);
        dispatch_async(GCDBackgroundThread, ^{
            success(responseObject);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        dispatch_async(GCDBackgroundThread, ^{
            failure(error);
        });
    }];
    [operation start];
}

- (void) sendPOSTHttpRequest: (NSString *) requestString withParams: (NSDictionary *) queryParams onSuccess:(onSuccessBlock)success
                   onfailure:(onErrorBlock)failure

{
//TODO: investigate it further why AFResquest isnt working.
//    AFHTTPRequestSerializer *requester = [[AFHTTPRequestSerializer alloc] init];
//    NSMutableURLRequest *request = [requester multipartFormRequestWithMethod:@"POST" URLString: requestString parameters: @{@"status": @"ignore"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSLog(@"%@", formData);
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", @"ignore"] dataUsingEncoding:NSUTF8StringEncoding] name:@"status"];
//    }];
//    [[FHSTwitterEngine sharedEngine] signRequest:request];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    
    NSString *boundary = [NSString generateUUID];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [[FHSTwitterEngine sharedEngine] signRequest:request];
    
    NSMutableData *body = [NSMutableData dataWithLength:0];
    
    for (NSString *key in queryParams.allKeys) {
        id obj = queryParams[key];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *data = nil;
        
        if ([obj isKindOfClass:[NSData class]]) {
            [body appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            data = (NSData *)obj;
        } else if ([obj isKindOfClass:[NSString class]]) {
            data = [[NSString stringWithFormat:@"%@\r\n",(NSString *)obj]dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:@(body.length).stringValue forHTTPHeaderField:@"Content-Length"];
    request.HTTPBody = body;

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Received: %@", responseObject);
        dispatch_async(GCDBackgroundThread, ^{
            success(responseObject);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        dispatch_async(GCDBackgroundThread, ^{
            failure(error);
        });
    }];
    [operation start];
}



@end
