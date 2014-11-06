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

@interface SCRecordButton ()

@property (nonatomic, assign) BOOL holding;

@end

@implementation SCRecordButton

@synthesize stateView = _stateView;

- (UIView*) stateView {
    if (!_stateView) {
        CGFloat offset = 4;
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(offset, offset, CGRectGetWidth(self.bounds)-offset*2, CGRectGetHeight(self.bounds)-offset*2)];
        _stateView.backgroundColor = [UIColor redColor];
    }
    return _stateView;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.holdingInterval = 0.4f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.stateView];
        
        CGFloat offset = self.stateView.frame.origin.x;
        CGFloat size = CGRectGetWidth(frame)-offset*2;
        [self.stateView autoCenterInSuperview];
        [self.stateView autoSetDimension:ALDimensionWidth toSize:size];
        [self.stateView autoSetDimension:ALDimensionHeight toSize:size];
        
        [self addTarget:self action:@selector(scaleToBig) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(scaleToDefault) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.stateView.layer.cornerRadius = CGRectGetHeight(self.stateView.frame) / 2;
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
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(.75f, .75f)];
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
