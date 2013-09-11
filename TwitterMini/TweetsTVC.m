//
//  TweetsTVC.m
//  TwitterMini
//
//  Created by nikhil.ji on 08/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "TweetsTVC.h"
#import "TimelineFetcher.h"
#import "TweetsCell.h"

@interface TweetsTVC ()
@property (nonatomic, strong) TimelineFetcher *tweetsFetcher;
@property (nonatomic, strong) NSArray *response;
@end

@implementation TweetsTVC

- (TimelineFetcher *)tweetsFetcher
{
    if (!_tweetsFetcher) _tweetsFetcher = [[TimelineFetcher alloc] init];
    return _tweetsFetcher;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tweetsFetcher fetchTimelineForUser:@"j1nd4L" withHandler:^(NSArray *response) {
        self.response = response;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.response count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(![cell isKindOfClass:[TweetsCell class]]) {
        return cell;
    }
    
    if(self.response) {
        int cellNumber = indexPath.row;
        NSDictionary *tweetContent = self.response[cellNumber];
        [cell initWithContent: tweetContent];
    }
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    NSUInteger PADDING_TOP = 16;
    if(self.response) {
        int cellNumber = indexPath.row;
        NSDictionary *tweetContent = self.response[cellNumber];
        UIFont *font = [UIFont systemFontOfSize:14];
        //Calculate the new size based on the text
        CGSize expectedLabelSize = [[tweetContent valueForKey:@"text"] sizeWithFont:font constrainedToSize:CGSizeMake(232, 6000) lineBreakMode: NSLineBreakByWordWrapping];
        cellHeight = expectedLabelSize.height + (2 * PADDING_TOP);
    }

    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end