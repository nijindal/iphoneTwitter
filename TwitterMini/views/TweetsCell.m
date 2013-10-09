#import "TweetsCell.h"
#import "User.h"
#import "Tweet.h"
#import "ThreadManager.h"
#import "Util.h"
#import "NSDate+NVTimeAgo.h"

@interface TweetsCell()
@property (nonatomic, weak) Tweet *tweet;
@end

static NSUInteger PADDING_TOP = 10;
static NSUInteger HANDLE_HEIGHT = 18;
static NSUInteger PADDING_HANDLE_BOTTOM = 5;
static NSUInteger PADDING_TWEET_BOTTOM = 5;
static NSUInteger HEIGHT_DATE = 18;
static NSUInteger PADDING_BOTTOM = 5;

static NSUInteger PADDING_LEFT = 10;
static NSUInteger PADDING_RIGHT = 10;
static NSUInteger IMAGE_WIDTH = 36;
static NSUInteger PADDING_IMAGE_RIGHT = 10;

static NSUInteger BUFFER_HEIGHT = 2;

@implementation TweetsCell

+ (NSUInteger) cellHeightInCurrentModeForText: (NSString *) text
{
    NSUInteger heightExceptTweetText =  (PADDING_TOP + HANDLE_HEIGHT + PADDING_HANDLE_BOTTOM + PADDING_TWEET_BOTTOM + HEIGHT_DATE + PADDING_BOTTOM);

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL isInPortraitMode =  (orientation == 0 || orientation == UIInterfaceOrientationPortrait);
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;

    NSUInteger tweetTextWidth = (isInPortraitMode ? screenSize.width : screenSize.height) - (PADDING_LEFT + PADDING_RIGHT + IMAGE_WIDTH + PADDING_IMAGE_RIGHT);

    CGRect expectedLabelSize = [text boundingRectWithSize:CGSizeMake(tweetTextWidth, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName: style} context:nil];

    NSUInteger cellHeight = ceil(expectedLabelSize.size.height) + heightExceptTweetText + BUFFER_HEIGHT;
    return cellHeight;
}


- (void) populateWithContent: (Tweet *) tweetData
{
    self.tweet = tweetData;
    self.tweetText.text = tweetData.text;
    self.handleLabel.text = [[NSString stringWithFormat: @"@%@", tweetData.tweetedBy.handle] description];
    self.date.text = [tweetData.time formattedAsTimeAgo];
    [self.tweetText sizeToFit];
    [self.tweetText layoutIfNeeded];
    [self.profileIcon setImage: [UIImage imageWithData:tweetData.tweetedBy.image_data] ?: [UIImage imageNamed:@"default-avatar"]];
}

@end
