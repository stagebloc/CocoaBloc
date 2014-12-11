//
//  SBOverlayView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/23/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBOverlayView.h"
#import "UIFont+FanClub.h"
#import <pop/POP.h>
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIView+Extension.h"

@interface SBOverlayView ()

@property (nonatomic, assign) NSTimeInterval showDuration;

@end

@implementation SBOverlayView

@synthesize activityIndicatorView = _activityIndicatorView, overlayToolbar = _overlayToolbar, titleLabel = _titleLabel, dismissLabel= _dismissLabel;

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont fc_fontWithSize:24];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel*) dismissLabel {
    if (!_dismissLabel) {
        _dismissLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dismissLabel.font = [UIFont fc_fontWithSize:14];
        _dismissLabel.textColor = [UIColor lightGrayColor];
        _dismissLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dismissLabel;
}

- (UIActivityIndicatorView*) activityIndicatorView {
    if (!_activityIndicatorView)
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    return _activityIndicatorView;
}

- (UIToolbar*) overlayToolbar {
    if (!_overlayToolbar) {
        _overlayToolbar = [[UIToolbar alloc] init];
        _overlayToolbar.barStyle = UIBarStyleBlack;
        _overlayToolbar.clipsToBounds = YES;
        _overlayToolbar.translucent = YES;
    }
    return _overlayToolbar;
}


- (instancetype) initWithFrame:(CGRect)frame text:(NSString*)text {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.overlayToolbar];
        [self.overlayToolbar autoCenterInSuperviewWithMatchedDimensions];
        
        [self addSubview:self.activityIndicatorView];
        [self.activityIndicatorView autoCenterInSuperview];
        [self.activityIndicatorView autoSetDimensionsToSize:CGSizeMake(30, 30)];
        [self.activityIndicatorView startAnimating];
        
        [self addSubview:self.titleLabel];
        self.titleLabel.text = text;
        [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.activityIndicatorView withOffset:-30];
        [self.titleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [self.titleLabel autoSetDimension:ALDimensionHeight toSize:30];
        
        self.dismissLabel.alpha = 0;
        [self addSubview:self.dismissLabel];
        self.dismissLabel.text = @"Tap to dismiss";
        [self.dismissLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-15];
        [self.dismissLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [self.dismissLabel autoSetDimension:ALDimensionHeight toSize:30];
        
        @weakify(self);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [tapGesture.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            if (self.dismissLabel.alpha == 1 && self.onDismissTap) {
                self.onDismissTap();
            }
        }];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Show
+ (instancetype) showInView:(UIView*)superview text:(NSString*)text {
    return [self showInView:superview text:text dismissOnTap:NO];
}

+ (instancetype) showInView:(UIView*)superview text:(NSString*)text dismissOnTap:(BOOL)dismissOnTap{
    return [self showInView:superview text:text dismissOnTap:dismissOnTap duration:0.5f];
}

+ (instancetype) showInView:(UIView*)superview text:(NSString*)text dismissOnTap:(BOOL)dismissOnTap duration:(NSTimeInterval)duration {
    SBOverlayView *view = [[SBOverlayView alloc] initWithFrame:superview.frame text:text];
    [superview addSubview:view];
    [view autoCenterInSuperviewWithMatchedDimensions];
    view.showDuration = duration;
    [view animateShowWithDuration:duration showDismissDialog:dismissOnTap completion:nil];
    return view;
}

#pragma mark - Dismiss
- (void) dismiss {
    [self dismissWithDuration:self.showDuration];
}

- (void) dismissAfter:(NSTimeInterval)delay {
    [self dismissWithDuration:self.showDuration delay:delay];
}

- (void) dismissWithDuration:(NSTimeInterval)duration {
    [self dismissWithDuration:duration delay:0];
}

- (void) dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    [self animateDismissWithDuration:duration delay:delay completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) dismissAfterError:(NSString*)error {
    [self animateOutActivityIndicatorWithDuration:self.showDuration completion:nil];
    [self animateError:error completion:^(BOOL finished) {
        [self dismissAfter:2];
    }];
}

- (void) dismissAfterText:(NSString*)text {
    [self animateOutActivityIndicatorWithDuration:self.showDuration completion:nil];
    [self animateText:text completion:^(BOOL finished) {
        [self dismissAfter:2];
    }];
}

#pragma mark - Animations
- (void) animateShowWithDuration:(NSTimeInterval)duration showDismissDialog:(BOOL)showDismissDialog completion:(void (^)(BOOL finished))completion{
    self.overlayToolbar.alpha = 0;
    [UIView animateWithDuration:duration/2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:.2f options:0 animations:^{
        self.overlayToolbar.alpha = 1;
    } completion:nil];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
    self.titleLabel.transform = transform;
    self.activityIndicatorView.transform = transform;
    transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.2f options:0 animations:^{
        self.titleLabel.transform = transform;
        self.activityIndicatorView.transform = transform;
    } completion:completion];
 
    if (showDismissDialog) {
        [UIView animateWithDuration:duration delay:3 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            self.dismissLabel.alpha = 1;
        } completion:nil];
    }
}

- (void) animateDismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:1 initialSpringVelocity:.2f options:0 animations:^{
        self.overlayToolbar.alpha = 0;
        self.titleLabel.alpha = 0;
        self.activityIndicatorView.alpha = 0;
    } completion:nil];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:.8f initialSpringVelocity:0.2f options:0 animations:^{
        self.titleLabel.transform = transform;
        self.activityIndicatorView.transform = transform;
    } completion:completion];
}

- (void) animateError:(NSString*)error completion:(void (^)(BOOL finished))completion {
    self.titleLabel.text = error;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if (completion)
            completion(finished);
    }];
    [self.titleLabel.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void) animateText:(NSString*)text completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:self.showDuration animations:^{
        self.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.titleLabel.text = text;
        [UIView animateWithDuration:self.showDuration animations:^{
            self.titleLabel.alpha = 1;
        } completion:completion];
    }];
}

- (void) animateOutActivityIndicatorWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2f options:0 animations:^{
        self.activityIndicatorView.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.2f options:0 animations:^{
        self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.2, 0.2);;
    } completion:completion];
}

@end
