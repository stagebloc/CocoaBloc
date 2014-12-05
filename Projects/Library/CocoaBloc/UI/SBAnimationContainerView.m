//
//  SBAnimationContainerView.m
//  CocoaBloc
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAnimationContainerView.h"
#import <PureLayout/PureLayout.h>

@implementation SBAnimationContainerView {
    NSArray *centering;
}

+ (instancetype)contain:(UIView *)animationView {
    SBAnimationContainerView *ret = [self new];
    ret.animationView = animationView;
    return ret;
}

- (CGSize)intrinsicContentSize {
    CGSize size = self.animationView.intrinsicContentSize;
    size.width += (self.animationViewInsets.left + self.animationViewInsets.right);
    size.height += (self.animationViewInsets.top + self.animationViewInsets.bottom);
    return size;
}

- (void)setAnimationView:(UIView *)animationView {
    if (animationView != _animationView) {
        if (centering) {
            [self removeConstraints:centering];
        }
        [_animationView removeFromSuperview];
        
        _animationView = animationView;
        [self addSubview:animationView];
        centering = [animationView autoCenterInSuperview];
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

@end
