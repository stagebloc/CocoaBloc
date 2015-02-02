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
    // only allow deleting 1 item at a time, and make sure it's a supported class
    
    return activityItems.count == 1 &&
    [activityItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !([evaluatedObject isKindOfClass:[SBContent class]] || [evaluatedObject isKindOfClass:[SBComment class]]);
    }]].count == 0;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.contentOrComment = [activityItems firstObject];
}

- (UIViewController *)activityViewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Content" message:@"Are you sure you want to do this?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        RACSignal *start = [self.contentOrComment isKindOfClass:[SBContent class]]
                                ? [self.client deleteContent:self.contentOrComment]
                                : [self.client deleteComment:self.contentOrComment];
        
        [[start
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeError:^(NSError *error) {
                @strongify(self);
                
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
