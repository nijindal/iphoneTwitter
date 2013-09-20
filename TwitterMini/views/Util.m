
#import "Util.h"
#import "ThreadManager.h"

@implementation Util

+ (void) assignDefaultImage: (UIImage *) defaultImage
                andFetchUrl: (NSString *) urlString
                onImageView: (UIImageView *) imageView
{
    [imageView setImage:defaultImage];
    dispatch_async(GCDBackgroundThread, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage: image];
        });
    });
}

+ (void) decorateDate: (NSDate *) date onLabel: (UILabel *)label
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString* result = [dateFormatter stringFromDate:date];
    [label setText:result];
}

@end
