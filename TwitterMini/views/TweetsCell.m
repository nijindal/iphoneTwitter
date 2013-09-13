//
//  TweetsCell.m
//  TwitterMini
//
//  Created by nikhil.ji on 08/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "TweetsCell.h"
#import "User.h"
#import "Tweet.h"

@implementation TweetsCell

- (void) populateWithContent: (Tweet *) tweetData
{
    self.tweetText.text = tweetData.text;
    self.handleLabel.text = [[NSString stringWithFormat: @"@%@", tweetData.tweetedBy.handle] description];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString* result = [dateFormatter stringFromDate:tweetData.time];
    [self.date setText:result];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("image fetcher", DISPATCH_QUEUE_SERIAL);
    dispatch_async(backgroundQueue, ^{
        UIImage *defaultImage = [UIImage imageNamed:@"default-avatar.png"];
        [self.profileIcon setImage:defaultImage];
        NSString *imageURL = tweetData.tweetedBy.image_url;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.profileIcon setImage: image];
        });
    });
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
