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
    [self.profileIcon setImage: [UIImage imageWithData:tweetData.tweetedBy.image_data]];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    int labelWidth = (orientation == 0 || orientation == UIInterfaceOrientationPortrait) ? 236 : 396;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize expectedLabelSize = [self.tweetText.text sizeWithFont:font constrainedToSize:CGSizeMake(labelWidth, 6000) lineBreakMode: NSLineBreakByWordWrapping];
    CGRect rect = self.tweetText.frame;
    rect.size.height = expectedLabelSize.height;
    self.tweetText.frame = rect;
}

@end
