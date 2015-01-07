//
//  SBToolBarAnimator.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBToolBarAnimator.h"

@implementation SBToolBarAnimator

@synthesize bgView = _bgView;

- (UIView*) bgView {
    if (!_bgView) {
        UIToolbar *toolBar = [[UIToolbar alloc] init];
        toolBar.barStyle = UIBarStyleBlack;
        toolBar.clipsToBounds = YES;
        toolBar.translucent = YES;
        _bgView = toolBar;
    }
    return _bgView;
}

#pragma mark - Animated Transitioning
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    
    if (self.type == SBAnimatorTypePresent || self.type == SBAnimatorTypePush) {
        
        [containerView addSubview:self.bgView];
        
        [containerView addSubview:toView];
        [self addMarginConstraintsToContainerView:containerView modalView:toView];
        
        CGRect endFrame = toView.frame;
        toView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
        self.bgView.frame = toView.frame;
        [containerView bringSubviewToFront:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            toView.frame = endFrame;
            self.bgView.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == SBAnimatorTypeDismiss || self.type == SBAnimatorTypePop) {
        CGRect endFrame = fromView.frame;
        endFrame.origin.y = containerView.frame.origin.y + containerView.frame.size.height;
        
        if (self.type == SBAnimatorTypePop)
            [containerView insertSubview:toView belowSubview:fromView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            fromView.frame = endFrame;
            self.bgView.frame = endFrame;
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
            [self removeMarginConstraintsFromContainerView:containerView];
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
