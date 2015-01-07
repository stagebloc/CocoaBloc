//
//  SBPushAnimator.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/7/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBPushAnimator.h"

@implementation SBPushAnimator

- (instancetype) init {
    if (self = [super init]) {
        self.direction = SBPushAnimatorDirectionRight;
    }
    return self;
}

#pragma mark - Animated Transitioning
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;

    UIView *inView = [transitionContext containerView];
    
    if (self.type == SBAnimatorTypePresent || self.type == SBAnimatorTypePush) {
        
        [inView addSubview:toView];
        
        CGRect fromViewFrame = fromView.frame;
        CGRect fromViewEndFrame = fromView.frame;

        CGRect toViewFrame = toView.frame;
        CGRect toViewEndFrame = toView.frame;
        switch (self.direction) {
            case SBPushAnimatorDirectionRight:
                toViewFrame.origin.x = CGRectGetWidth(toViewEndFrame);
                fromViewEndFrame.origin.x = -CGRectGetWidth(toViewEndFrame)/2;
                break;
            case SBPushAnimatorDirectionLeft:
                toViewFrame.origin.x = -CGRectGetWidth(toViewEndFrame);
                fromViewEndFrame.origin.x = CGRectGetWidth(toViewEndFrame)/2;
                break;
            case SBPushAnimatorDirectionUp:
                toViewFrame.origin.y = -CGRectGetHeight(toViewEndFrame);
                fromViewEndFrame.origin.y = CGRectGetHeight(toViewEndFrame)/2;
                break;
            case SBPushAnimatorDirectionDown:
                toViewFrame.origin.y = CGRectGetHeight(toViewEndFrame);
                fromViewEndFrame.origin.y = -CGRectGetHeight(toViewEndFrame)/2;
                break;
            default:
                [NSException raise:NSInternalInconsistencyException format:@"direction is not valid"];
                break;
        }
        
        fromView.frame = fromViewFrame;
        toView.frame = toViewFrame;
        [inView bringSubviewToFront:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            toView.frame = toViewEndFrame;
            fromView.frame = fromViewEndFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == SBAnimatorTypeDismiss || self.type == SBAnimatorTypePop) {
        CGRect toViewEndFrame = toView.frame;
        toViewEndFrame.origin = CGPointMake(0, 0);
        
        CGRect toViewFrame = toView.frame;
        CGRect fromViewEndFrame = fromView.frame;
        switch (self.direction) {
            case SBPushAnimatorDirectionRight:
                toViewFrame.origin.x = -CGRectGetWidth(toViewEndFrame)/2;
                fromViewEndFrame.origin.x = CGRectGetWidth(fromViewEndFrame);
                break;
            case SBPushAnimatorDirectionLeft:
                toViewFrame.origin.x = CGRectGetWidth(toViewEndFrame)/2;
                fromViewEndFrame.origin.x = -CGRectGetWidth(fromViewEndFrame);
                break;
            case SBPushAnimatorDirectionUp:
                toViewFrame.origin.y = CGRectGetHeight(toViewEndFrame)/2;
                fromViewEndFrame.origin.y = -CGRectGetHeight(fromViewEndFrame);
                break;
            case SBPushAnimatorDirectionDown:
                toViewFrame.origin.y = -CGRectGetHeight(toViewEndFrame)/2;
                fromViewEndFrame.origin.y = CGRectGetHeight(fromViewEndFrame);
                break;
            default:
                [NSException raise:NSInternalInconsistencyException format:@"direction is not valid"];
                break;
        }
        
        if (self.type == SBAnimatorTypePop) {
            toView.frame = toViewFrame;
            [inView insertSubview:toView belowSubview:fromView];
        }

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            toView.frame = toViewEndFrame;
            fromView.frame = fromViewEndFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
