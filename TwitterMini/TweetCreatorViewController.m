#import "TweetCreatorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ApiInterface.h"
#import "ThreadManager.h"

@interface TweetCreatorViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetArea;
- (IBAction)sendTweet:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic) int count;
- (IBAction)dismissModal:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *charCount;
@end

@implementation TweetCreatorViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[self.tweetArea layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.tweetArea layer] setBorderWidth:2.3];
}

- (void) textViewDidChange:(UITextView *)textView
{
    int length = 140-[self.tweetArea.text length];
    self.charCount.text = [NSString stringWithFormat:@"%d", length];
    self.charCount.textColor = (length>=0) ? [UIColor blackColor]: [UIColor redColor];
}

- (IBAction)sendTweet:(UIBarButtonItem *)sender {
    NSString *tweetText = [self.tweetArea text];
    if(tweetText.length == 0 || tweetText.length > 140){
        return;
    }
    dispatch_async(GCDBackgroundThread, ^{
        self.sendButton.enabled = NO;
        [[ApiInterface sharedInstance] postTweet:tweetText onSuccess:^{
            self.sendButton.enabled = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        } onFailure:^(NSError *error) {
            self.sendButton.enabled = YES;
            NSLog(@"Error occured %@", error);
            NSLog(@"Error occured. Please try again");
        }];
    });
    
}
- (IBAction)dismissModal:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
