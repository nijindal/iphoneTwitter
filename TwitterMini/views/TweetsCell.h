//
//  TweetsCell.h
//  TwitterMini
//
//  Created by nikhil.ji on 08/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileIcon;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

- (void) initWithContent: (id) content;

@end
