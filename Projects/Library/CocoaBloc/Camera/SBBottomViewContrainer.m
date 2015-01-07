//
//  SBBottomViewContrainer.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBBottomViewContrainer.h"
#import <PureLayout/PureLayout.h>
#import "UIView+Extension.h"

@interface SBBottomViewContrainer ()

@property (nonatomic, strong) NSArray *constraints;

@end

@implementation SBBottomViewContrainer

- (BOOL) isVisible {
    return !(self.frame.origin.y > self.superview.bounds.size.height);
}

- (void) initDefaults {
    [super initDefaults];
    
    self.height = 200;
    
    _toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    _toolbar.barStyle = UIBarStyleBlack;
    _toolbar.clipsToBounds = YES;
    _toolbar.translucent = YES;

    [self addSubview:_toolbar];
    [_toolbar autoCenterInSuperviewWithMatchedDimensions];
    
    self.hidden = YES;
}

- (void) adjustConstraintsHidden:(BOOL)isHidden {
    [self.constraints autoRemoveConstraints];
    NSMutableArray *constraints = [NSMutableArray array];
    
    CGFloat height = self.height;
    CGFloat offset = 30;
    [constraints addObject:[self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview]];
    [constraints addObject:[self autoSetDimension:ALDimensionHeight toSize:height]];
    [constraints addObject:[self autoAlignAxis:ALAxisVertical toSameAxisOfView:self.superview]];
    
    self.topRestriction = @(self.superview.frame.size.height - height);
    
    if (!isHidden) {
        [constraints addObject:[self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.superview withOffset:offset]];
    } else {
        [constraints addObject:[self autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.superview withOffset:1]];
    }
    
    if (!isHidden) {
        self.hidden = NO;
    }
    
    self.constraints = [constraints copy];
}

- (void) toggleHidden {
    [self toggleHiddenWithCustomAnimations:nil completion:nil];
}

- (void) toggleHiddenWithCustomAnimations:(void(^)(BOOL shouldHide))customAnimations completion:(void(^)(BOOL finished))completion {
    BOOL shouldHide = [self isVisible];
    [self adjustConstraintsHidden:shouldHide];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:0 animations:^{
        [self.superview layoutSubviews];
        if (customAnimations) customAnimations(shouldHide);
    } completion:^(BOOL finished) {
        if (![self isVisible]) self.hidden = YES;
    }];
}

#pragma mark - Subclassing
- (void) stoppedMovingWithVelocity:(CGPoint)velocity {
    BOOL shouldHide = velocity.y == 0 ? !(self.frame.origin.y <= self.topRestriction.floatValue + self.frame.size.height*.2f) : velocity.y > 0;
    [self adjustConstraintsHidden:shouldHide];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:velocity.y options:0 animations:^{
        [self.superview layoutSubviews];
        if (self.stoppedMovingAnimations) self.stoppedMovingAnimations(shouldHide);
    } completion:^(BOOL finished) {
        if (![self isVisible]) self.hidden = YES;
        if (self.stoppedMovingCompletion) self.stoppedMovingCompletion(finished);
    }];
}

@end
