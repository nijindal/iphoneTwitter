//
//  TweetsCDTVC.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "TimelineFetcher.h"
#import "FHSTwitterEngine.h"
#import "ApiUtil.h"
#import "ThreadManager.h"

@interface TweetsCDTVC : CoreDataTableViewController

@property (nonatomic, strong) TimelineFetcher *tweetsFetcher;
@property (nonatomic, strong) ThreadManager *threadManager;
@property (nonatomic) int height;

- (void) loadTweets;
- (void) checkForNewTweets;

@end
