#import "ProfileTVC.h"
#import "UsersCDTVC.h"
#import "FHSTwitterEngine.h"
#import "Util.h"
#import "UserProfileManager.h"
#import "ThreadManager.h"

@interface ProfileTVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *tweets;
@property (weak, nonatomic) IBOutlet UITableViewCell *following;
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *friends;
@property (strong, nonatomic) User *user;
@end

@implementation ProfileTVC

- (void) initWithUser: (User*) user
{
    self.user = user;
    [self populateProfile:user];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if(!self.user) {
        dispatch_async(GCDBackgroundThread, ^{
            [UserProfileManager fetchOwnerProfileWithSuccessHandler:^(User *user) {
                dispatch_async(GCDMainThread, ^{
                    self.user = (User *)[[[ThreadManager sharedInstance] mainThreadContext] objectWithID:[user objectID]];
                    [self populateProfile: self.user];
                });
            }];
        });
    } else {
        [self populateProfile:self.user];
    }
}

- (void) populateProfile: (User *)user
{
    self.tweets.detailTextLabel.text = [user.tweet_count stringValue];
    self.friends.detailTextLabel.text = [user.friends_count stringValue];
    self.following.detailTextLabel.text = [user.followers_count stringValue];
    self.nameLabel.text = user.name;
    [self.imageView setImage:[UIImage imageWithData:user.image_data]];
    dispatch_async(GCDBackgroundThread, ^{
        UIImage *biggerImage = [[FHSTwitterEngine sharedEngine] getProfileImageForUsername:user.handle andSize:FHSTwitterEngineImageSizeBigger];
        dispatch_async(GCDMainThread, ^{
            [self.imageView setImage: biggerImage];
        });
    });
    if(user.banner_url){
        dispatch_async(GCDBackgroundThread, ^{
            NSData *imageData = [NSData dataWithContentsOfURL: [Util createMobileBannerUrl:user.banner_url]];
            dispatch_async(GCDMainThread, ^{
                [self.profileBanner setImage:[UIImage imageWithData:imageData]];
            });
        });
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UsersCDTVC *destinationController = (UsersCDTVC*) segue.destinationViewController;
    destinationController.designatedUser = self.user;
    if([segue.identifier isEqualToString:@"ShowFollowers"]){
        destinationController.tableType = @"Followers";
    }
    if([segue.identifier isEqualToString:@"ShowFriends"]){
        destinationController.tableType = @"Friends";
    }
}


@end
