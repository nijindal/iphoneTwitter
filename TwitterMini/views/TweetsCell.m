#import "TweetsCell.h"
#import "User.h"
#import "Tweet.h"
#import "ThreadManager.h"
#import "Util.h"
#import "NSDate+NVTimeAgo.h"

@interface TweetsCell()
@property (nonatomic, weak) Tweet *tweet;
@end

@implementation TweetsCell

- (void) populateWithContent: (Tweet *) tweetData
{
    self.tweet = tweetData;
    self.tweetText.text = tweetData.text;
    self.handleLabel.text = [[NSString stringWithFormat: @"@%@", tweetData.tweetedBy.handle] description];
    self.date.text = [tweetData.time formattedAsTimeAgo];
    [self.profileIcon setImage: [UIImage imageWithData:tweetData.tweetedBy.image_data] ?: [UIImage imageNamed:@"default-avatar"]];
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
