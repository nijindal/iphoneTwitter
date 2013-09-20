#import "SingleTweetViewController.h"
#import "User.h"
#import "Util.h"

@interface SingleTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

@implementation SingleTweetViewController

- (void) fillInAttributes
{
    self.name.text = self.tweet.tweetedBy.name;
    self.handle.text = [NSString stringWithFormat:@"@%@", self.tweet.tweetedBy.handle];
    self.tweetText.text = self.tweet.text;
    [Util assignDefaultImage:[UIImage imageNamed:@"avatar-default"] andFetchUrl:self.tweet.tweetedBy.image_url onImageView: self.imageView];
    [Util decorateDate:self.tweet.time onLabel:self.time];
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

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self fillInAttributes];
}

- (void) awakeFromNib
{
    NSLog(@"Awoken from NIB");
}

@end
