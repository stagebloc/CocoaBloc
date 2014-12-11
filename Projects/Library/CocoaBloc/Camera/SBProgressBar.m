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
    
    if (value == self.minValue)
        [_stopValues removeAllObjects];
    
    [self setNeedsDisplay];
}

- (id) init {
    return [self initWithMinValue:0 maxValue:10];
}

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.options = SBProgressBarOptionsHorizontal | SBProgressBarOptionsLeftToRight;
        _minValue = minValue;
        _maxValue = maxValue;
    }
    return self;
}

- (BOOL) isRightToLeft {
    return (SBProgressBarOptions)(self.options & SBProgressBarOptionsRightToLeft) == SBProgressBarOptionsRightToLeft;
}

- (BOOL) isVertical {
    return (SBProgressBarOptions)(self.options & SBProgressBarOptionsVertical) == SBProgressBarOptionsVertical;
}

- (CGFloat) xOrYPositionFromValue:(CGFloat)value {
    CGFloat widthHeight = self.isVertical ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame);
    CGFloat mult = widthHeight / (self.maxValue - self.minValue);
    return value * mult;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //draw line
    CGRect toFillRect = rect;
    
    if (self.isRightToLeft) {
        if (self.isVertical) toFillRect.origin.y = CGRectGetHeight(rect) - [self xOrYPositionFromValue:self.value];
        else toFillRect.origin.x = CGRectGetWidth(rect) - [self xOrYPositionFromValue:self.value];
    } else {
        if (self.isVertical) toFillRect.size.height = [self xOrYPositionFromValue:self.value];
        else toFillRect.size.width = [self xOrYPositionFromValue:self.value];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1, 1, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 1, 1, 1.0);
    CGContextFillRect(context, toFillRect);

    //draw stop values
    NSArray *values = [self.stopValues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]]];
    NSInteger len = values.count;
    for (int i = 0; i < len; i++) {
        CGFloat stopVal = [values[i] floatValue];
        CGFloat pos = [self xOrYPositionFromValue:stopVal];
        
        //don't draw the last line if the stopVal is about equal to self.value
        if (i == len-1 && self.value >= stopVal-.05 && self.value <= stopVal+.05)
            return;
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.65 alpha:1].CGColor);
        CGContextSetLineWidth(context, 1.0f);
        
        if (self.isRightToLeft) {
            pos = self.isVertical ? CGRectGetHeight(rect) - pos : CGRectGetWidth(rect) - pos;
        }
        
        if (self.isVertical) {
            CGContextMoveToPoint(context, 0.0f, pos);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), pos);
        } else {
            CGContextMoveToPoint(context, pos, 0.0f);
            CGContextAddLineToPoint(context, pos, CGRectGetHeight(rect));
        }
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