#import "TweetsCDTVC.h"
#import "Tweet.h"
#import "Tweet+create.h"
#import "TweetsCell.h"

@implementation TweetsCDTVC

- (void) viewDidLoad
{
    UINib *tweetNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"TweetCell"];
    [self.refreshControl addTarget:self action:@selector(refetchTweets) forControlEvents:UIControlEventValueChanged];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.context) [self loadTweets];
}

- (TimelineFetcher *)tweetsFetcher
{
    if (!_tweetsFetcher) _tweetsFetcher = [[TimelineFetcher alloc] init];
    return _tweetsFetcher;
}

- (void) loadTweets {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Tweets"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            self.context = document.managedObjectContext;
            [self refetchTweets];
        }];
    } else if(document.documentState == UIDocumentStateClosed){
        [document openWithCompletionHandler:^(BOOL success) {
            self.context = document.managedObjectContext;
            [self refetchTweets];
        }];
    } else {
        self.context = document.managedObjectContext;
    }
}

- (void) refetchTweets {
    [self.refreshControl endRefreshing];
}

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


@end
