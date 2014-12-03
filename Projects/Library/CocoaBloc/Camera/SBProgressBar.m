//
//  SCProgressBarView.m
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBProgressBar.h"

@interface SBProgressBar ()

@end

@implementation SBProgressBar

@synthesize minValue = _minValue, maxValue = _maxValue, stopValues = _stopValues;

- (NSMutableSet*) stopValues {
    if (!_stopValues)
        _stopValues = [[NSMutableSet alloc] init];
    return _stopValues;
}

- (void) setValue:(CGFloat)value {
    if (value < self.minValue) value = self.minValue;
    else if (value > self.maxValue) value = self.maxValue;
    _value = value;
    [self setNeedsDisplay];
}

- (id) init {
    return [self initWithMinValue:0 maxValue:10];
}

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _minValue = minValue;
        _maxValue = maxValue;
    }
    return self;
}

- (CGFloat) xPositionFromValue:(CGFloat)value {
    CGFloat mult = CGRectGetWidth(self.frame) / (self.maxValue - self.minValue);
    return value * mult;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //draw line
    CGRect toFillRect = rect;
    toFillRect.size.width = [self xPositionFromValue:self.value];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1, 1, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 1, 1, 1.0);
    CGContextFillRect(context, toFillRect);

    //draw stop values
    NSArray *values = [self.stopValues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]]];
    NSInteger len = values.count;
    for (int i = 0; i < len; i++) {
        CGFloat stopVal = [values[i] floatValue];
        CGFloat xPos = [self xPositionFromValue:stopVal];
        
        //don't draw the last line if the stopVal is about equal to self.value
        if (i == len-1 && self.value >= stopVal-.05 && self.value <= stopVal+.05)
            return;
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.65 alpha:1].CGColor);
        CGContextSetLineWidth(context, 1.0f);
        CGContextMoveToPoint(context, xPos, 0.0f);
        CGContextAddLineToPoint(context, xPos, rect.size.height);
        CGContextStrokePath(context);
    }
}

#pragma mark - Set
- (void) addCurrentValueToStopValues {
    [self addStopValuesObject:@(self.value)];
}
- (void) addStopValuesObject:(NSNumber *)value {
    [self.stopValues addObject:value];
}
- (void) removeStopValuesObject:(NSNumber *)value {
    [self.stopValues removeObject:value];
}

@end