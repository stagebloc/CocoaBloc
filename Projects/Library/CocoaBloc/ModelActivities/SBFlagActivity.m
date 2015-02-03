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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"Please choose the reason why you're flagging this." preferredStyle:UIAlertControllerStyleActionSheet];
    
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"Offensive" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        RACSignal *start = isContent
            ? [self.client flagContent:self.contentOrComment reason:SBAPIMethodParameterFlagContentValueOffensive]
            : [self.client flagComment:self.contentOrComment reason:SBAPIMethodParameterFlagContentValueOffensive];
        
        [[start
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeError:^(NSError *error) {
                @strongify(self);
                
                NSString *reason;
                if ([error.domain isEqualToString:SBCocoaBlocErrorDomain]) {
                    reason = error.userInfo[SBAPIErrorResponseLocalizedErrorString];
                } else {
                    reason = error.localizedDescription;
                }
                
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Flagging Error" message:reason preferredStyle:UIAlertControllerStyleAlert];
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
                
                [self activityDidFinish:NO];
            }
            completed:^{
                @strongify(self);
             
                [self activityDidFinish:YES];
            }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Prejudice" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        RACSignal *start = isContent
        ? [self.client flagContent:self.contentOrComment reason:SBAPIMethodParameterFlagContentValuePrejudice]
        : [self.client flagComment:self.contentOrComment reason:SBAPIMethodParameterFlagContentValuePrejudice];
        
        [[start
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeError:^(NSError *error) {
                @strongify(self);
             
                NSString *reason;
                if ([error.domain isEqualToString:SBCocoaBlocErrorDomain]) {
                    reason = error.userInfo[SBAPIErrorResponseLocalizedErrorString];
                } else {
                    reason = error.localizedDescription;
                }
                
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Flagging Error" message:reason preferredStyle:UIAlertControllerStyleAlert];
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
                
                [self activityDidFinish:NO];
            }
            completed:^{
                @strongify(self);
             
                [self activityDidFinish:YES];
            }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Copyright" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        RACSignal *start = isContent
        ? [self.client flagContent:self.contentOrComment reason:SBAPIMethodParameterFlagContentValueCopyright]
        : [self.client flagComment:self.contentOrComment reason:SBAPIMethodParameterFlagContentValueCopyright];
        
        [[start
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeError:^(NSError *error) {
                @strongify(self);
                
                NSString *reason;
                if ([error.domain isEqualToString:SBCocoaBlocErrorDomain]) {
                    reason = error.userInfo[SBAPIErrorResponseLocalizedErrorString];
                } else {
                    reason = error.localizedDescription;
                }
                
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Flagging Error" message:reason preferredStyle:UIAlertControllerStyleAlert];
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
                
                [self activityDidFinish:NO];
            }
            completed:^{
                @strongify(self);
                
                [self activityDidFinish:YES];
            }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Duplicate" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        RACSignal *start = isContent
        ? [self.client flagContent:self.contentOrComment reason:SBAPIMethodParameterFlagContentValueDuplicate]
        : [self.client flagComment:self.contentOrComment reason:SBAPIMethodParameterFlagContentValueDuplicate];
        
        [[start
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeError:^(NSError *error) {
                @strongify(self);
                
                NSString *reason;
                if ([error.domain isEqualToString:SBCocoaBlocErrorDomain]) {
                    reason = error.userInfo[SBAPIErrorResponseLocalizedErrorString];
                } else {
                    reason = error.localizedDescription;
                }
                
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Flagging Error" message:reason preferredStyle:UIAlertControllerStyleAlert];
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