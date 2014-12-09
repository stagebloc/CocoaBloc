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

- (void) createMaskLayer:(SBFadeLabelType)type {
    if (type == SBFadeLabelTypeFadeNone)
        return;
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.startPoint = CGPointMake(0.0f, .5f);
    maskLayer.endPoint = CGPointMake(1.f, .5f);
    
    UIColor *leftColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    UIColor *rightColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    switch (type) {
        case SBFadeLabelTypeFadeLeft:
            maskLayer.locations = @[@0.0, @0.15, @0.5, @1.0f];
            leftColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            rightColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            break;
        case SBFadeLabelTypeFadeRight:
            maskLayer.locations = @[@0.0, @.5, @0.85f, @1.0f];
            leftColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            rightColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            break;
        case SBFadeLabelTypeFadeAll:
            maskLayer.locations = @[@0.0, @0.25, @.75, @1.0f];
            leftColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            rightColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            break;
        default:
            break;
    }
    
    maskLayer.colors = @[(id)leftColor.CGColor, (id)leftColor.CGColor, (id)rightColor.CGColor, (id)rightColor.CGColor];
    maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    self.layer.mask = maskLayer;
}

- (void) setType:(SBFadeLabelType)type {
    [self willChangeValueForKey:@"type"];
    _type = type;
    [self didChangeValueForKey:@"type"];
    
    self.layer.mask = nil;
    [self createMaskLayer:type];
}

- (instancetype) initWithText:(NSString*)text {
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.mask.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

@end
