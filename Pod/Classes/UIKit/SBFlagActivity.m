//
//  SBFlagActivity.m
//  Pods
//
//  Created by John Heaton on 2/2/15.
//
//

#import "SBFlagActivity.h"

#import "SBComment.h"
#import "SBStatus.h"
#import "SBBlog.h"
#import "SBClient+Comment.h"
#import "SBClient+Content.h"
#import <ReactiveCocoa/RACExtScope.h>
#import "SBFlagViewController.h"

NSString *const SBFlagActivityType = @"SBFlagActivityType";

@interface SBFlagActivity () <SBFlagViewControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) SBClient *client;
@property (nonatomic) id contentOrComment;
@end

@implementation SBFlagActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (instancetype)initWithClient:(SBClient *)c {
    if (!(self = [super init])) return nil;
    
    self.client = c;
    
    return self;
}

- (NSString *)activityType {
    return SBFlagActivityType;
}

- (NSString *)activityTitle {
    return @"Flag";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"SBFlagActivity"];
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

- (void)flagViewControllerFinishedWithType:(NSString *)type reason:(NSString *)reason {
    BOOL isContent = [self.contentOrComment isKindOfClass:[SBContent class]];
    
    RACSignal *start = isContent
        ? [self.client flagContent:self.contentOrComment type:type reason:reason]
        : [self.client flagComment:self.contentOrComment type:type reason:reason];
    
    [[start
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeError:^(NSError *error) {
            [self activityDidFinish:NO];
        }
        completed:^{
            [self activityDidFinish:YES];
        }];
}

- (UIViewController *)activityViewController {
    SBFlagViewController *flag = [[SBFlagViewController alloc] init];
    flag.delegate = self;
        
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flag];
    nav.delegate = self;
    
    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(flagActivity:willDisplayViewController:)]) {
        [self.delegate flagActivity:self willDisplayViewController:(SBFlagViewController *)viewController];
    }
}

@end