#import "TweetsCDTVC.h"
#import "Tweet.h"
#import "Tweet+create.h"
#import "TweetsCell.h"
#import "SingleTweetViewController.h"

@implementation TweetsCDTVC

- (void) loadTweets {}

- (ThreadManager*) threadManager
{
    if(_threadManager) {
        return _threadManager;
    }
    _threadManager = [[ThreadManager alloc] init];
    return _threadManager;
}

- (TimelineFetcher *)tweetsFetcher
{
    if (!_tweetsFetcher) _tweetsFetcher = [[TimelineFetcher alloc] init];
    return _tweetsFetcher;
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

- (void) viewDidLoad
{
    UINib *tweetNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"TweetCell"];
    [self.refreshControl addTarget:self action:@selector(checkForNewTweets) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void) refreshTable: (NSNotification *) notification
{
    [self.fetchResultsController.managedObjectContext mergeChangesFromContextDidSaveNotification: notification];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTweets];
}

- (void) checkForNewTweets {
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    NSString *username = [[FHSTwitterEngine sharedEngine] loggedInUsername];
    if (username.length > 0) {
        [self fetchData];
        [self.refreshControl endRefreshing];
    } else {
        [[FHSTwitterEngine sharedEngine] showOAuthLoginControllerFromViewController:self withCompletion: ^(BOOL success) {
            [self fetchData];
            [self.refreshControl endRefreshing];
        }];
    }
}

- (void) fetchData {}

- (void) fetchOldTweets {}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
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
    
    Tweet *tweet = [self.fetchResultsController objectAtIndexPath:indexPath];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize expectedLabelSize = [tweet.text sizeWithFont:font constrainedToSize:CGSizeMake(226, 6000) lineBreakMode: NSLineBreakByWordWrapping];
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

//    float reload_distance = 10;
    if(y == h) {
        [self fetchOldTweets];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowTweet" sender:cell];
}

@end
