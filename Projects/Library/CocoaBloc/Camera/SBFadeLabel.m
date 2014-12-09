//
//  SBFadeLabel.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBFadeLabel.h"
#import "NSMutableAttributedString+Extensions.h"

@interface SBFadeLabel ()

@end

@implementation SBFadeLabel

- (CAGradientLayer*) gradientMask {
    return (CAGradientLayer*)self.layer.mask;
}

- (void) createMaskLayer:(SBFadeLabelType)type {
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    
    NSDictionary *options = [self optionsForType:type];
    
    maskLayer.startPoint = [[options objectForKey:@"startPoint"] CGPointValue];
    maskLayer.endPoint = [[options objectForKey:@"endPoint"] CGPointValue];
    
    UIColor *hideColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    UIColor *halfColor = [UIColor colorWithWhite:1.0 alpha:0.3f];
    UIColor *showColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    maskLayer.locations =  [options objectForKey:@"locations"];
    
    maskLayer.colors = @[(id)hideColor.CGColor, (id)hideColor.CGColor, (id)halfColor.CGColor, (id)halfColor.CGColor, (id)showColor.CGColor, (id)showColor.CGColor];
    maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    self.layer.mask = maskLayer;
}

- (NSDictionary*) optionsForType:(SBFadeLabelType)type {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    switch (type) {
        case SBFadeLabelTypeFadeLeft:
            [dictionary setObject:@[@0, @.2f, @.25f, @0.35f, @.6f, @1.0f] forKey:@"locations"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, .5f)] forKey:@"startPoint"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, .5f)] forKey:@"endPoint"];
            break;
        case SBFadeLabelTypeFadeRight:
            [dictionary setObject:@[@0, @.2f, @.25f, @0.35f, @.6f, @1.0f] forKey:@"locations"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, .5f)] forKey:@"startPoint"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, .5f)] forKey:@"endPoint"];
            break;
        case SBFadeLabelTypeFadeAll:
            [dictionary setObject:@[@0, @1.0f, @1.0f, @1.0f, @1.0f, @1.0f] forKey:@"locations"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, .5f)] forKey:@"startPoint"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, .5f)] forKey:@"endPoint"];
            break;
        default: //None
            [dictionary setObject:@[@0, @0.0f, @0.0f, @0.0f, @0.0f, @1.0f] forKey:@"locations"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(0.0f, .5f)] forKey:@"startPoint"];
            [dictionary setObject:[NSValue valueWithCGPoint:CGPointMake(1.0f, .5f)] forKey:@"endPoint"];
            break;
    }
    return dictionary;
}

- (void) setType:(SBFadeLabelType)type {
    [self willChangeValueForKey:@"type"];
    _type = type;
    [self didChangeValueForKey:@"type"];
    
    [self animateTypeChange:type];
}

- (instancetype) initWithText:(NSString*)text {
    if (self = [super init]) {
        self.text = text;
        [self createMaskLayer:SBFadeLabelTypeFadeNone];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.mask.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - Animations
- (void) animateTypeChange:(SBFadeLabelType)type {
    [CATransaction begin];
    
    NSDictionary *options = [self optionsForType:type];
    NSTimeInterval duration = 1.5f;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = self.gradientMask.locations;
    animation.toValue = [options objectForKey:@"locations"];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer.mask addAnimation:animation forKey:@"locations"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"startPoint"];
    animation.fromValue = [NSValue valueWithCGPoint:self.gradientMask.startPoint];
    animation.toValue = [options objectForKey:@"startPoint"];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer.mask addAnimation:animation forKey:@"startPoint"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    animation.fromValue = [NSValue valueWithCGPoint:self.gradientMask.endPoint];
    animation.toValue = [options objectForKey:@"endPoint"];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer.mask addAnimation:animation forKey:@"endPoint"];

    [CATransaction commit];
}

@end
