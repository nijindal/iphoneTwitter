#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (void) assignDefaultImage: (UIImage *) image andFetchUrl: (NSString *) urlString onImageView: (UIImageView *) imageView;

+ (void) decorateDate: (NSDate *) date onLabel: (UILabel *)label;

@end