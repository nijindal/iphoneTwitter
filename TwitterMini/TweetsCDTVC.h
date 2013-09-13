//
//  TweetsCDTVC.h
//  TwitterMini
//
//  Created by nikhil.ji on 11/09/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "TimelineFetcher.h"

@interface TweetsCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) TimelineFetcher *tweetsFetcher;

- (void) refetchTweets;

@end
