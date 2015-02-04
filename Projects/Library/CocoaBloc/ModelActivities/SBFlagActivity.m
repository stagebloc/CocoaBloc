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
#import "SBFlagActivityViewController.h"
#import <RACEXTScope.h>

NSString *const SBFlagActivityType = @"SBFlagActivityType";

@interface SBFlagActivity ()
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
    return [UIImage imageNamed:@"FlagActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return activityItems.count == 1;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    NSAssert([activityItems.firstObject isKindOfClass:[SBComment class]]
             || [activityItems.firstObject isKindOfClass:[SBContent class]], @"Activity item is not a supported class");
    
    self.contentOrComment = [activityItems firstObject];
}

- (UIViewController *)activityViewController {
    NSString *title;
    
    BOOL isContent = [self.contentOrComment isKindOfClass:[SBContent class]];
    BOOL isComment = [self.contentOrComment isKindOfClass:[SBComment class]];
    
    if (isContent) {
        title = @"Flag Content";
    } else if (isComment) {
        title = @"Flag Comment";
    }
    
    SBFlagActivityViewController *flag = [[SBFlagActivityViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flag];
    
    return flag;
}

@end