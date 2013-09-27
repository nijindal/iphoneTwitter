#import <Foundation/Foundation.h>
#import "Tweet.h"
#import "TweetsCell.h"

@interface Util : NSObject

+ (void) decorateDate: (NSDate *) date onLabel: (UILabel *)label;

+ (NSURL *) createMobileBannerUrl : (NSString *)savedUrl;

@end