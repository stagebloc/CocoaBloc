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
@property (nonatomic) SBUser *user;
@property (nonatomic) SBAccount *account;
@end

@implementation SBBanUserActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (instancetype)initWithClient:(SBClient *)client {

    if (!(self = [super init])) return nil;

    self.client = client;

    return self;
}

- (NSString *)activityType {
    return SBBanUserActivityType;
}

- (NSString *)activityTitle {
    return @"Ban Fan";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"SBBanActivity"];
}

-(void)banUserViewControllerCancelled:(SBBanUserViewController *)controller {
    [self activityDidFinish:NO];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return activityItems.count == 2;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {

    NSAssert([activityItems.firstObject isKindOfClass:[SBUser class]]
             && [activityItems.lastObject isKindOfClass:[SBAccount class]], @"One or both item is not a supported class");

    self.user = (SBUser*)activityItems.firstObject;
    self.account = (SBAccount*)activityItems.lastObject;
}

-(void)banUserViewControllerFinishedWithReason:(NSString *)reason {

    @weakify(self);
    [[[self.client banUserWithID:self.user.identifier
               fromAccountWithID:self.account.identifier
                          reason:reason]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeError:^(NSError *error) {
         @strongify(self);
         [self activityDidFinish:NO];
     } completed:^{
         @strongify(self);
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
