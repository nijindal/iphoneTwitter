//
//  LoginViewController.m
//  TwitterMini
//
//  Created by nikhil.ji on 08/10/13.
//  Copyright (c) 2013 directi. All rights reserved.
//

#import "LoginViewController.h"
#import "FHSTwitterEngine.h"

@interface LoginViewController ()<FHSTwitterEngineAccessTokenDelegate>

@end

@implementation LoginViewController

- (void)awakeFromNib
{
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:@"W7z7KpZNxVxD3UnUHVBdnQ" andSecret:@"EmR8ldrd1mtNSvDcl307LfpMAAdq9Nhqa8acNLI84"];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
}

- (NSString *)loadAccessToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)storeAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    if(![[FHSTwitterEngine sharedEngine] isAuthorized]){
        [[FHSTwitterEngine sharedEngine] showOAuthLoginControllerFromViewController:self withCompletion:nil];
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"InitialController"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    }
}

@end
