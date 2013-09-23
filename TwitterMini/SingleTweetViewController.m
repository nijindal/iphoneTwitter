#import "SingleTweetViewController.h"
#import "User.h"
#import "Util.h"
#import "ThreadManager.h"

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
    
    NSString *imageUrl = self.tweet.tweetedBy.image_url;
    [self.imageView setImage: [UIImage imageNamed:@"default-avatar.png"]];
    dispatch_async(GCDBackgroundThread, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.tweet.tweetedBy.image_url isEqualToString:imageUrl]){
                [self.imageView setImage: image];
            }
        });
    });
    
    
    [Util assignDefaultImage:[UIImage imageNamed:@"avatar-default"] andFetchUrl:self.tweet.tweetedBy.image_url onImageView: self.imageView onTweetCell:NULL];
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
