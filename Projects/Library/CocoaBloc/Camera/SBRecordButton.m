//
//  SCRecordButton.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBRecordButton.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+FanClub.h"
#import "UIView+Extension.h"

#import <pop/POP.h>

@interface SBRecordButton ()

@property (nonatomic, strong) NSLayoutConstraint *verticalConstraint;

@end

@implementation SBRecordButton

@synthesize innerView = _innerView, state = _state;

- (UIView*) innerView {
    if (!_innerView) {
        CGFloat offset = 4;
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(offset, offset, CGRectGetWidth(self.bounds)-offset*2, CGRectGetHeight(self.bounds)-offset*2)];
        _innerView.backgroundColor = [UIColor clearColor];
        _innerView.layer.borderColor = [UIColor fc_stageblocBlueColor].CGColor;
        _innerView.layer.borderWidth = 1.5f;
        _innerView.userInteractionEnabled = NO;
    }
    return _innerView;
}

- (void) setBorderColor:(UIColor*)borderColor {
    _innerView.layer.borderColor = borderColor.CGColor;
}

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.alpha = enabled ? 1 : 0.5;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.holdingInterval = .5f;
        self.allowHold = YES;
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.innerView];
        
        CGFloat offset = self.innerView.frame.origin.x;
        CGFloat size = CGRectGetWidth(frame)-offset*2;
        [self.innerView autoCenterInSuperview];
        [self.innerView autoSetDimension:ALDimensionWidth toSize:size];
        [self.innerView autoSetDimension:ALDimensionHeight toSize:size];
        
        [self addTarget:self action:@selector(touchedDown) forControlEvents:UIControlEventTouchDown ];
        [self addTarget:self action:@selector(touchedUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
        self.innerView.layer.cornerRadius = CGRectGetHeight(self.innerView.frame) / 2;
    }
    return self;
}

- (void) didHold {
//    if (self.verticalConstraint)
//        [self removeConstraint:self.verticalConstraint];
    
    self.holding = YES;
    [self scaleToBig];
    if ([self.delegate respondsToSelector:@selector(recordButtonStartedHolding:)]) {
        [self.delegate recordButtonStartedHolding:self];
    }
}

- (void) cancelHold {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didHold) object:nil];
//    if (self.verticalConstraint && ![self.constraints containsObject:self.verticalConstraint]) {
//        [self addConstraint:self.verticalConstraint];
//    }
}

- (NSLayoutConstraint*) autoAlignVerticalAxisToSuperview {
    self.verticalConstraint = [self autoAlignAxisToSuperviewAxis:ALAxisVertical];
    return self.verticalConstraint;
}

#pragma mark - Touch Methods
- (void) touchedDown {
    if (self.allowHold) {
        [self cancelHold];
        [self performSelector:@selector(didHold) withObject:nil afterDelay:self.holdingInterval];
    }
}

- (void) touchedUp {
    [self cancelHold];
    
    //hold
    if (self.allowHold && self.holding) {
        [self scaleNormal];
        if ([self.delegate respondsToSelector:@selector(recordButtonStoppedHolding:)])
            [self.delegate recordButtonStoppedHolding:self];
    }
    //tap
    else {
        if ([self.delegate respondsToSelector:@selector(recordButtonTapped:)])
            [self.delegate recordButtonTapped:self];
    }
    
    self.holding = NO;
}

#pragma mark - Animations
- (void)scaleToBig {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
    scaleAnimation.springBounciness = 10.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)scaleNormal {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness = 10.0f;
    
    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

@end
