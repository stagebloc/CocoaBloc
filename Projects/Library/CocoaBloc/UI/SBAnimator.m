//
//  SBAnimator.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAnimator.h"

@implementation SBAnimator

- (id) init {
    if (self = [super init]) {
        self.transitionSpeed = 0.5f;
        self.type = SBAnimatorTypePresent;
    }
    return self;
}

#pragma mark - Animated Transitioning
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [NSException raise:NSInternalInconsistencyException format:@"Override animateTransition: in subclass"];
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionSpeed;
}

@end
