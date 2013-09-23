#import <Foundation/Foundation.h>
#import "Tweet.h"
#import "TweetsCell.h"

@interface Util : NSObject

+ (void) assignDefaultImage: (UIImage *) image andFetchUrl: (NSString *) urlString onImageView: (UIImageView *) imageView onTweetCell: (TweetsCell *) tweetCell;

+ (void) decorateDate: (NSDate *) date onLabel: (UILabel *)label;

@end