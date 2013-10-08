#import "SingleTweetViewController.h"
#import "User.h"
#import "Util.h"
#import "ThreadManager.h"
#import "ProfileTVC.h"
#import "NSDate+NVTimeAgo.h"

@interface SingleTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

@implementation SingleTweetViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self fillInAttributes];
}

- (void) fillInAttributes
{
    self.name.text = self.tweet.tweetedBy.name;
    self.handle.text = [NSString stringWithFormat:@"@%@", self.tweet.tweetedBy.handle];
    self.tweetText.text = self.tweet.text;
    [self.imageView setImage:[UIImage imageWithData:self.tweet.tweetedBy.image_data] ?: [UIImage imageNamed:@"default-avatar"]];
    self.time.text = [self.tweet.time formattedAsTimeAgo];
    [self handleTweetLabelSize];
}

- (void) handleTweetLabelSize
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize expectedLabelSize = [self.tweet.text sizeWithFont:font constrainedToSize:CGSizeMake(280, 480) lineBreakMode: NSLineBreakByWordWrapping];
    CGRect rect = self.tweetText.frame;
    rect.size.height = expectedLabelSize.height;
    self.tweetText.frame = rect;
    [self.view layoutIfNeeded];
}

@end
