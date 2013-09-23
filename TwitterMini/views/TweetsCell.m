#import "TweetsCell.h"
#import "User.h"
#import "Tweet.h"
#import "ThreadManager.h"
#import "Util.h"

@interface TweetsCell()
@property (nonatomic, weak) Tweet *tweet;
@end

@implementation TweetsCell

- (void) populateWithContent: (Tweet *) tweetData
{
    self.tweet = tweetData;
    self.tweetText.text = tweetData.text;
    self.handleLabel.text = [[NSString stringWithFormat: @"@%@", tweetData.tweetedBy.handle] description];
    [Util decorateDate: tweetData.time onLabel: self.date];
    NSString *imageUrl = tweetData.tweetedBy.image_url;
//    [Util assignDefaultImage:[UIImage imageNamed:@"default-avatar.png"] andFetchUrl:tweetData.tweetedBy.image_url onImageView:self.profileIcon onTweet: self.tweet];
    [self.profileIcon setImage: [UIImage imageNamed:@"default-avatar.png"]];
    dispatch_async(GCDBackgroundThread, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.tweet.tweetedBy.image_url isEqualToString:imageUrl]){
                [self.profileIcon setImage: [UIImage imageWithData: imageData]];
            } else {
                NSLog(@"URL not same.");
            }
        });
    });
}

- (void) layoutSubviews {
    [super layoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    int labelWidth = (orientation == 0 || orientation == UIInterfaceOrientationPortrait) ? 236 : 396;
    UIFont *font = [UIFont systemFontOfSize:14];
    NSLog(@"%d", labelWidth);
    CGSize expectedLabelSize = [self.tweetText.text sizeWithFont:font constrainedToSize:CGSizeMake(labelWidth, 6000) lineBreakMode: NSLineBreakByWordWrapping];
    CGRect rect = self.tweetText.frame;
    rect.size.height = expectedLabelSize.height;
    self.tweetText.frame = rect;
}

@end
