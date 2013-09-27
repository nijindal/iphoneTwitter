#import "Util.h"
#import "ThreadManager.h"
#import "User.h"

@implementation Util

+ (void) decorateDate: (NSDate *) date onLabel: (UILabel *)label
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString* result = [dateFormatter stringFromDate:date];
    [label setText:result];
}

+ (NSURL *) createMobileBannerUrl : (NSString *)savedUrl
{
    return  [NSURL URLWithString: [NSString stringWithFormat:@"%@/mobile", savedUrl]];
}

@end
