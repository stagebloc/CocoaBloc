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

@interface SBRecordButton ()

@property (nonatomic, assign) BOOL holding;

@end

@implementation SBRecordButton

@synthesize innerView = _innerView;

- (UIView*) innerView {
    if (!_innerView) {
        CGFloat offset = 4;
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(offset, offset, CGRectGetWidth(self.bounds)-offset*2, CGRectGetHeight(self.bounds)-offset*2)];
        _innerView.backgroundColor = [UIColor clearColor];
        _innerView.layer.borderColor = [UIColor fc_stageblocBlueColor].CGColor;
        _innerView.layer.borderWidth = 1.5f;
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
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.innerView.layer.cornerRadius = CGRectGetHeight(self.innerView.frame) / 2;
}

- (void) didHold {
    self.holding = YES;
    [self scaleToBig];
    if ([self.delegate respondsToSelector:@selector(recordButtonStartedHolding:)]) {
        [self.delegate recordButtonStartedHolding:self];
    }
}

- (void) cancelHold {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didHold) object:nil];
}

#pragma mark - Touch Methods
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.allowHold) {
        [self cancelHold];
        [self performSelector:@selector(didHold) withObject:nil afterDelay:self.holdingInterval];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

//helper
- (void) touchesEndedOrCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self cancelHold];
    
    //hold
    if (self.allowHold && self.holding) {
        NSLog(@"Did stop holding");
        
        [self scaleNormal];
        if ([self.delegate respondsToSelector:@selector(recordButtonStoppedHolding:)])
            [self.delegate recordButtonStoppedHolding:self];
    }
    //tap
    else {
        NSLog(@"Did tap");
        if ([self.delegate respondsToSelector:@selector(recordButtonTapped:)])
            [self.delegate recordButtonTapped:self];
    }
    
    self.holding = NO;
}


#pragma mark - Animations
- (void)scaleToBig {
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:.5 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scaleNormal {
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:.5 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

@end
