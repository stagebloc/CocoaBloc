//
//  SBMarginAnimator.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBMarginAnimator.h"

@implementation SBMarginAnimator

//just a clear view for now
//override or setBgview  and change
- (UIView*) bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
        _bgView.alpha = 0;
    }
    return _bgView;
}

- (instancetype) init {
    if (self = [super init]) {
        self.margins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void) addMarginConstraintsToContainerView:(UIView*)containerView modalView:(UIView*)modalView {
    modalView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(containerView, modalView);
    NSString *hFormat = [NSString stringWithFormat:@"H:|-%d-[modalView]-%d-|", (int) self.margins.left, (int) self.margins.right];
    NSString *vFormat = [NSString stringWithFormat:@"V:|-%d-[modalView]-%d-|", (int) self.margins.top, (int)self.margins.bottom];
    self.constraints = [[NSLayoutConstraint constraintsWithVisualFormat:hFormat options:0 metrics:nil views:views] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:views]];
    [containerView addConstraints:self.constraints];
}

- (void) removeMarginConstraintsFromContainerView:(UIView*)containerView {
    [containerView removeConstraints:self.constraints];
}

#pragma mark - Animated Transitioning
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    
    if (self.type == SBAnimatorTypePresent || self.type == SBAnimatorTypePush) {
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        self.bgView.frame = containerView.frame;
        [containerView addSubview:self.bgView];
        
        [containerView addSubview:modalView];
        [self addMarginConstraintsToContainerView:containerView modalView:modalView];
        
        CGRect endFrame = modalView.frame;
        modalView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
        [containerView bringSubviewToFront:modalView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            modalView.frame = endFrame;
            self.bgView.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == SBAnimatorTypeDismiss || self.type == SBAnimatorTypePop) {
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        
        CGRect endFrame = modalView.frame;
        endFrame.origin.y = containerView.frame.origin.y + containerView.frame.size.height;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            modalView.frame = endFrame;
            self.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
            [self removeMarginConstraintsFromContainerView:containerView];
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
