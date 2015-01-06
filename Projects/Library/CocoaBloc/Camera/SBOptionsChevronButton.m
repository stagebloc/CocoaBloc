//
//  SBOptionsChevronButton.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBOptionsChevronButton.h"
#import "UIView+Extension.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation SBOptionsChevronButton

- (void) setBottomContainerView:(SBBottomViewContrainer *)bottomContainerView {
    [self willChangeValueForKey:@"bottomContainerView"];
    _bottomContainerView = bottomContainerView;
    _bottomContainerView.dragDelegate = self;
    [self didChangeValueForKey:@"bottomContainerView"];
}

- (void) initDefaults {
    [super initDefaults];
    self.imageView.image = [UIImage imageNamed:@"arrow_down"];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self rotateToHidden:YES];
    [self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void) pressed {
    if (!self.bottomContainerView) return;
    
    @weakify(self);
    [self.bottomContainerView toggleHiddenWithCustomAnimations:^(BOOL shouldHide) {
        @strongify(self);
        [self rotateToHidden:shouldHide];
    } completion:nil];
}

- (void) rotateToHidden:(BOOL)isHidden {
    //.00001 is a little tweak/hack to keep animation direction consistent
    self.transform = isHidden ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(.00001);
}

#pragma mark - SBBottomViewContrainerDelegate
- (SBBottomViewContrainerCustomAnimations) bottomViewContainerDidStopMoving:(SBBottomViewContrainer *)view {
    return ^ (CGPoint velocity, BOOL shouldHide) {
        [self rotateToHidden:shouldHide];
    };
}

- (void) draggableViewDidMove:(SBDraggableView *)view {
    CGFloat bottomRestriction = (self.superview.superview.frame.size.height+1) - view.topRestriction.floatValue;
    CGFloat percentage = (view.frame.origin.y - view.topRestriction.floatValue) / bottomRestriction;
    CGFloat angle = M_PI * percentage;
    if (angle <= 0) angle = .00001;
    self.transform = CGAffineTransformMakeRotation(angle);
}

@end
