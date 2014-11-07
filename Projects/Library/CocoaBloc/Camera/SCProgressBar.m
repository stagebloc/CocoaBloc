//
//  SCProgressBarView.m
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCProgressBar.h"

@interface SCProgressBar ()

@property (nonatomic) NSTimer *timer;
@property (nonatomic, copy) NSDate *timerStartDate;
@property (nonatomic) NSTimeInterval pauseTimeElapsed;

@end

@implementation SCProgressBar

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
        _state = SCProgressStateStopped;
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

#pragma mark - Timer Methods
- (BOOL) start {
    if (self.state == SCProgressStateStarted)
        return NO;
    
    _state = SCProgressStateStarted;
    
    self.timerStartDate = [NSDate date];
    CGFloat duration = 0.01f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
    if ([self.delegate respondsToSelector:@selector(progressBarDidStart:)]) {
        [self.delegate progressBarDidStart:self];
    }
    
    return YES;
}

- (BOOL) pause {
    if (self.state == SCProgressStatePaused)
        return NO;
    
    _state = SCProgressStatePaused;
    
    [self.timer invalidate];
    self.pauseTimeElapsed = self.timeElapsed;
    
    if ([self.delegate respondsToSelector:@selector(progressBarDidPause:)]) {
        [self.delegate progressBarDidPause:self];
    }
    
    return YES;
}

- (BOOL) stop {
    if (self.state == SCProgressStateStopped)
        return NO;
    
    _state = SCProgressStateStopped;
    
    [self.timer invalidate];
    
    if ([self.delegate respondsToSelector:@selector(progressBarDidStop:withTime:)]) {
        [self.delegate progressBarDidStop:self withTime:self.timeElapsed];
    }
    
    return YES;
}

- (void) update:(NSTimer*)timer {
    self.timeElapsed = self.pauseTimeElapsed + [[NSDate date] timeIntervalSinceDate:self.timerStartDate];
    self.value = self.timeElapsed;
    if(self.timeElapsed >= self.maxValue) {
        [self stop];
    }
}

@end