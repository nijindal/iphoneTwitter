//
//  TweetsCell.m
//  TwitterMini
//
//  Created by nikhil.ji on 08/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "TweetsCell.h"

@implementation TweetsCell

- (void) initWithContent: (id) content
{
    NSString *text = [content valueForKey:@"text"];
    [self.tweetText setText: text];
    NSDictionary *user = [content valueForKey:@"user"];
    NSString *imageURL = [user valueForKey:@"profile_image_url"];
//    [self.profileIcon setImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize expectedLabelSize = [self.tweetText.text sizeWithFont:font constrainedToSize:CGSizeMake(232, 6000) lineBreakMode: NSLineBreakByWordWrapping];
    CGRect rect = self.tweetText.frame;
    rect.size.height = expectedLabelSize.height;
    self.tweetText.frame = rect;
}

@end
