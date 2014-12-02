//
//  SBOverlayView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/23/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBOverlayView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readonly) UIToolbar *overlayToolbar;

+ (instancetype) showInView:(UIView*)superview text:(NSString*)text;
+ (instancetype) showInView:(UIView*)superview text:(NSString*)text duration:(NSTimeInterval)duration;

- (instancetype) initWithFrame:(CGRect)frame text:(NSString*)text;

- (void) dismiss;
- (void) dismissAfter:(NSTimeInterval)delay;
- (void) dismissAfterError:(NSString*)error;
- (void) dismissAfterText:(NSString*)text;
- (void) dismissWithDuration:(NSTimeInterval)duration;
- (void) dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

- (void) animateError:(NSString*)error completion:(void (^)(BOOL finished))completion;
- (void) animateText:(NSString*)text completion:(void (^)(BOOL finished))completion;



@end
