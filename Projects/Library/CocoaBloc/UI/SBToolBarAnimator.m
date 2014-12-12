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
    UIView *containerView = [transitionContext containerView];
    
    if (self.type == SBAnimatorTypePresent || self.type == SBAnimatorTypePush) {
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        [containerView addSubview:self.bgView];
        
        [containerView addSubview:modalView];
        [self addMarginConstraintsToContainerView:containerView modalView:modalView];
        
        CGRect endFrame = modalView.frame;
        modalView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
        self.bgView.frame = modalView.frame;
        [containerView bringSubviewToFront:modalView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            modalView.frame = endFrame;
            self.bgView.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == SBAnimatorTypeDismiss || self.type == SBAnimatorTypePop) {
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        
        CGRect endFrame = modalView.frame;
        endFrame.origin.y = containerView.frame.origin.y + containerView.frame.size.height;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            modalView.frame = endFrame;
            self.bgView.frame = endFrame;
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
            [self removeMarginConstraintsFromContainerView:containerView];
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
