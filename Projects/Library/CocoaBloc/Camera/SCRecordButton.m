//
//  SCRecordButton.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SCRecordButton.h"
#import <PureLayout/PureLayout.h>
#import <pop/POP.h>
#import "UIColor+FanClub.h"

@interface SCRecordButton ()

@property (nonatomic, assign) BOOL holding;

@end

@implementation SCRecordButton

@synthesize innerView = _innerView;

- (UIView*) innerView {
    if (!_innerView) {
        CGFloat offset = 4;
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(offset, offset, CGRectGetWidth(self.bounds)-offset*2, CGRectGetHeight(self.bounds)-offset*2)];
        _innerView.backgroundColor = [UIColor whiteColor];
        _innerView.layer.borderColor = [UIColor fc_stageblocBlueColor].CGColor;
        _innerView.layer.borderWidth = 1.5f;
    }
    return _innerView;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.holdingInterval = 0.4f;
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
    if ([self.delegate respondsToSelector:@selector(recordButtonStartedHolding:)]) {
        [self.delegate recordButtonStartedHolding:self];
    }
}

#pragma mark - Touch Methods
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self performSelector:@selector(didHold) withObject:nil afterDelay:self.holdingInterval];
    
    [self scaleToBig];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didHold) object:nil];
    
    [self scaleBackAnimation];

    //hold
    if (self.holding) {
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
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2f, 1.2f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleBackAnimation {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(.8f, .8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault {
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

@end
