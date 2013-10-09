//
//  TweetsCell.h
//  TwitterMini
//
//  Created by nikhil.ji on 08/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileIcon;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;

+ (NSUInteger) cellHeightInCurrentModeForText: (NSString *) text;
- (void) populateWithContent: (Tweet *) content;

@end
