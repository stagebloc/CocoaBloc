//
//  SCProgressBarView.m
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBProgressBar.h"

@interface SBProgressBar ()

@property (nonatomic) NSTimer *timer;
@property (nonatomic, copy) NSDate *timerStartDate;
@property (nonatomic) NSTimeInterval pauseTimeElapsed;

@end

@implementation SBProgressBar

@synthesize minValue = _minValue, maxValue = _maxValue, state = _state;

- (UIView*) progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
    }
    return _progressView;
}

- (void) setValue:(CGFloat)value {
    if (value < self.minValue) value = self.minValue;
    else if (value > self.maxValue) value = self.maxValue;
    _value = value;
    [self animateToValue:value];
}

- (id) init {
    return [self initWithMinValue:0 maxValue:10];
}

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.progressView];
        self.progressView.backgroundColor = [UIColor whiteColor];
        _minValue = minValue;
        _maxValue = maxValue;
        _state = SBProgressStateStopped;
    }
    return self;
}

- (void) animateToValue:(CGFloat)value {
    value = value - self.minValue;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect frame = self.progressView.frame;
    frame.origin.x = 0;
    
    CGFloat mult = CGRectGetWidth(self.frame) / (self.maxValue - self.minValue);
    frame.size.width = value * mult;
    
    self.progressView.frame = frame;
}

@end