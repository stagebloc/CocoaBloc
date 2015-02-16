//
//  SBDeleteActivity.m
//  CocoaBloc
//
//  Created by John Heaton on 1/30/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBDeleteActivity.h"
#import "SBComment.h"
#import "SBStatus.h"
#import "SBBlog.h"
#import "SBClient+Comment.h"
#import "SBClient+Content.h"
#import <RACEXTScope.h>

NSString *const SBDeleteActivityType = @"SBDeleteActivity";

@interface SBDeleteActivity ()
@property (nonatomic) SBClient *client;
@property (nonatomic) id contentOrComment;
@end

@implementation SBDeleteActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (instancetype)initWithClient:(SBClient *)c {
    if (!(self = [super init])) return nil;
    
    self.client = c;
    
    return self;
}

- (NSString *)activityType {
    return SBDeleteActivityType;
}

- (NSString *)activityTitle {
    return @"Delete";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"DeleteActivity"];
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
    RACSignal *start;
    
    if ([self.contentOrComment isKindOfClass:[SBContent class]]) {
        title = @"Delete Content";
        start = [self.client deleteContent:self.contentOrComment];
    } else if ([self.contentOrComment isKindOfClass:[SBComment class]]) {
        title = @"Delete Comment";
        start = [self.client deleteComment:self.contentOrComment];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"Are you sure you want to do this?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[start
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeError:^(NSError *error) {
                @strongify(self);
                
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Deletion Error" message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleAlert];
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
                
                [self activityDidFinish:NO];
            }
            completed:^{
                @strongify(self);
                
                [self activityDidFinish:YES];
            }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self activityDidFinish:NO];
    }]];
    
    return alert;
}

@end
