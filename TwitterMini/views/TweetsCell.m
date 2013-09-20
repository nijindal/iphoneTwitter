#import "TweetsCell.h"
#import "User.h"
#import "Tweet.h"
#import "ThreadManager.h"
#import "Util.h"

@implementation TweetsCell

- (void) populateWithContent: (Tweet *) tweetData
{
    self.tweetText.text = tweetData.text;
    self.handleLabel.text = [[NSString stringWithFormat: @"@%@", tweetData.tweetedBy.handle] description];
    [Util decorateDate: tweetData.time onLabel: self.date];
    [Util assignDefaultImage:[UIImage imageNamed:@"default-avatar.png"] andFetchUrl:tweetData.tweetedBy.image_url onImageView:self.profileIcon];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize expectedLabelSize = [self.tweetText.text sizeWithFont:font constrainedToSize:CGSizeMake(226, 6000) lineBreakMode: NSLineBreakByWordWrapping];
    CGRect rect = self.tweetText.frame;
    rect.size.height = expectedLabelSize.height;
    self.tweetText.frame = rect;
}

@end
