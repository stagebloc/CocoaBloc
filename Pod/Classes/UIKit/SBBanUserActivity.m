//
//  SBBanUserActivity.m
//  Pods
//
//  Created by David Warner on 7/1/15.
//
//

#import "SBBanUserActivity.h"
#import "SBClient+User.h"

NSString *const SBBanUserActivityType = @"SBBanActivityType";

@interface SBBanUserActivity () <SBBanUserViewControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) SBClient *client;
@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *accountID;
@end

@implementation SBBanUserActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (instancetype)initWithClient:(SBClient *)client
                        userID:(NSNumber* )userID
                     accountID:(NSNumber *)accountID {

    if (!(self = [super init])) return nil;

    self.client = client;
    self.userID = userID;
    self.accountID = accountID;

    return self;
}

- (NSString *)activityType {
    return SBBanUserActivityType;
}

- (NSString *)activityTitle {
    return @"Ban User";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"SBBanActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return activityItems.count == 1;
}

-(void)banUserViewControllerCancelled:(SBBanUserViewController *)controller {
    [self activityDidFinish:NO];
}

-(void)banUserViewControllerFinishedWithReason:(NSString *)reason {

    [[[self.client banUserWithID:self.userID fromAccountWithID:self.accountID reason:reason]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeError:^(NSError *error) {
         [self activityDidFinish:NO];

     } completed:^{
         [self activityDidFinish:YES];
     }];
}

- (UIViewController *)activityViewController {
    SBBanUserViewController *banUser = [[SBBanUserViewController alloc] init];
    banUser.delegate = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:banUser];
    nav.delegate = self;

    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(banActivity:willDisplayViewController:)]) {
        [self.delegate banActivity:self willDisplayViewController:(SBBanUserViewController *)viewController];
    }
}

@end
