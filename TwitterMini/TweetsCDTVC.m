
#import "TweetsCDTVC.h"
#import "Tweet+create.h"
#import "TweetsCell.h"
#import "SingleTweetViewController.h"

@implementation TweetsCDTVC

- (void)awakeFromNib
{
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:@"W7z7KpZNxVxD3UnUHVBdnQ" andSecret:@"EmR8ldrd1mtNSvDcl307LfpMAAdq9Nhqa8acNLI84"];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UINib *tweetNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"TweetCell"];

    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    if(![[FHSTwitterEngine sharedEngine] isAuthorized]){
        [[FHSTwitterEngine sharedEngine] showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
            if(success) [self fetchData];
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupFetchController];
}

- (NSString *)loadAccessToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)storeAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = [self.fetchResultsController objectAtIndexPath:indexPath];
    if(![cell isKindOfClass:[TweetsCell class]]){
        return cell;
    }
    [cell populateWithContent: tweet];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight;
    NSUInteger PADDING_TOP = 28;
    NSUInteger HEIGHT_DATE = 30;
    NSUInteger labelWidth;
    
    Tweet *tweet = [self.fetchResultsController objectAtIndexPath:indexPath];
    UIFont *font = [UIFont systemFontOfSize:14];
    labelWidth = (self.tableView.frame.size.width == 320) ? 236 : 396;
    CGSize expectedLabelSize = [tweet.text sizeWithFont:font constrainedToSize:CGSizeMake(labelWidth, 6000) lineBreakMode: NSLineBreakByWordWrapping];
    cellHeight = expectedLabelSize.height + (PADDING_TOP + HEIGHT_DATE);
    return cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(y == h) {
        [self fetchOldTweets];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowTweet" sender:cell];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    Tweet *tweet = [self.fetchResultsController objectAtIndexPath:path];
    id destinationController = segue.destinationViewController;
    if(![destinationController isKindOfClass:[SingleTweetViewController class]]){
        return;
    }
    destinationController = (SingleTweetViewController *) destinationController;
    [destinationController setTweet: tweet];
}

#pragma mark - Abstract methods.

- (void) setupFetchController {}

- (void) fetchData {}

- (void) fetchOldTweets {}


@end
