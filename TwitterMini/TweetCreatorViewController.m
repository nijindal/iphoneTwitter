//
//  TweetCreatorViewController.m
//  TwitterMini
//
//  Created by nikhil.ji on 23/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "TweetCreatorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FHSTwitterEngine.h"
#import "ThreadManager.h"

@interface TweetCreatorViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetArea;
- (IBAction)sendTweet:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic) int count;
@property (weak, nonatomic) IBOutlet UILabel *charCount;
@end

@implementation TweetCreatorViewController

- (void) viewDidLoad
{
    [[self.tweetArea layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.tweetArea layer] setBorderWidth:2.3];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [self.placeHolder removeFromSuperview];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [self.view addSubview:self.placeHolder];
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
        NSError *error = [[FHSTwitterEngine sharedEngine] postTweet: tweetText];
        self.sendButton.enabled = NO;
        if(!error) {
            NSLog(@"No error. Awesome..");
            dispatch_async(GCDMainThread, ^{
                self.tweetArea.text = @"";
                self.sendButton.enabled = YES;
            });
        }
    });

}
@end
