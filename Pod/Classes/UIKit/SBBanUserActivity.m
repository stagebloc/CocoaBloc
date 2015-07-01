//
//  SBBanUserActivity.m
//  Pods
//
//  Created by David Warner on 7/1/15.
//
//

#import "SBBanUserActivity.h"

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

- (instancetype)initWithClient:(SBClient *)client userID:(NSNumber* )userID accountID:(NSNumber *)accountID {
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
    return [UIImage imageNamed:@"SBBanUserActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return activityItems.count == 1;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    NSAssert([activityItems.firstObject isKindOfClass:[SBComment class]]
             || [activityItems.firstObject isKindOfClass:[SBContent class]], @"Activity item is not a supported class");

    self.contentOrComment = [activityItems firstObject];
}

- (void)flagViewControllerCancelled:(SBFlagViewController *)controller {
    [self activityDidFinish:NO];
}

-(void)banUserViewControllerFinishedWithReason:(NSString *)reason {

//    RACSignal *start = isContent
//    ? [self.client flagContent:self.contentOrComment type:type reason:reason]
//    : [self.client flagComment:self.contentOrComment type:type reason:reason];
//
//    [[start
//      deliverOn:[RACScheduler mainThreadScheduler]]
//     subscribeError:^(NSError *error) {
//         [self activityDidFinish:NO];
//     }
//     completed:^{
//         [self activityDidFinish:YES];
//     }];

}

- (UIViewController *)activityViewController {
    SBBanUserViewController *banUser = [[SBBanUserViewController alloc] init];
    banUser.delegate = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:banUser];
    nav.delegate = self;

    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(flagActivity:willDisplayViewController:)]) {
        [self.delegate flagActivity:self willDisplayViewController:(SBFlagViewController *)viewController];
    }
}

@end
