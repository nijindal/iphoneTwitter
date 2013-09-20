#import "TimelineFetcher.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ApiUtil.h"

@interface TimelineFetcher()
@property (nonatomic) ACAccountStore *accountStore;
@end

@implementation TimelineFetcher

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)fetchHomeTimelineForUser : (NSString *)username
                     withHandler : (responseHandler) handler
{
    NSDictionary *requestParams = @{@"screen_name" : username,
                                    @"include_rts" : @"1",
                                    @"trim_user" : @"0",
                                    @"count" : @"25"};
    
    [self makeApiCall:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
           withParams:requestParams
          withHandler:handler];
}

- (void) fetchSelfTimelineForUser:(NSString *)username withHandler:(responseHandler)handler
{
    NSDictionary *requestParams = @{@"screen_name" : username,
                                    @"include_rts" : @"1",
                                    @"trim_user" : @"0",
                                    @"count" : @"25"};
    
    [self makeApiCall:@"https://api.twitter.com/1.1/statuses/user_timeline.json"
           withParams:requestParams
          withHandler:handler];
}


- (void) makeApiCall : (NSString*) apiString
          withParams : (NSDictionary*) params
         withHandler : (responseHandler) handler
{
    if ([self userHasAccessToTwitter]) {
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString: apiString];
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                         requestMethod:SLRequestMethodGET
                                                                   URL:url
                                                            parameters:params];
                 [request setAccount:[twitterAccounts lastObject]];
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             id timelineData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if ([timelineData isKindOfClass:[NSArray class]]) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                                 timelineData = [ApiUtil changeTweetsArray:timelineData];
                                 NSArray *tweetsArray = (NSArray*) timelineData;
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     handler(tweetsArray);
                                 });
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter];
}


@end
