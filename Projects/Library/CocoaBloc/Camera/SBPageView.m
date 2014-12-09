//
//  SCPageView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/7/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBPageView.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+FanClub.h"
#import "NSMutableAttributedString+Extensions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "SBFadeLabel.h"

@interface SBPageView ()

@property (nonatomic, strong) NSArray *constraints;

@end

@implementation SBPageView

- (UIColor*) selectedColor {
    if (!_selectedColor)
        _selectedColor = [UIColor whiteColor];
    return _selectedColor;
}
- (UIColor*) deselectedColor {
    if (!_deselectedColor)
        _deselectedColor = [UIColor whiteColor];
    return _deselectedColor;
}

- (void) setIndex:(NSInteger)index {
    [self setIndex:index duration:self.animationDuration];
}

- (void) setIndex:(NSInteger)index duration:(NSTimeInterval)duration {
    if (index < 0) index = 0;
    if (index >= self.labels.count) index = self.labels.count - 1;
    
    [self willChangeValueForKey:@"index"];
    _index = index;
    [self didChangeValueForKey:@"index"];
    
    [self configureLayoutWithDuration:duration];
}

- (void) configureLayoutWithDuration:(NSTimeInterval)duration {
    [self.constraints autoRemoveConstraints];
    
    CGFloat const Padding = 15;
    NSUInteger count = self.labels.count;
    
    NSMutableArray *layoutConstraints = [NSMutableArray array];
    
    SBFadeLabel *baseLabel = self.labels[self.index];
    baseLabel.textColor = [self.selectedColor copy];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    NSMutableAttributedString *baseString = [baseLabel.attributedText mutableCopy];
    [baseLabel setType:SBFadeLabelTypeFadeNone];
    baseLabel.attributedText = baseString;
    
    //left of base label
    long start = self.index-1;
    for (long i = start; i >= 0; i--) {
        SBFadeLabel *pinLabel = i == start ? baseLabel : self.labels[i+1];
        SBFadeLabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:pinLabel withOffset:-Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        if (self.fadeOut) {
            if (i == start) {
                [label setType:SBFadeLabelTypeFadeLeft];
            } else {
                [label setType:SBFadeLabelTypeFadeAll];
            }
        } else {
            [label setType:SBFadeLabelTypeFadeNone];
        }
    }
    //right of base label
    start = self.index+1;
    for (long i = start; i < count; i++) {
        SBFadeLabel *pinLabel = i == start ? baseLabel : self.labels[i-1];
        SBFadeLabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pinLabel withOffset:Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        if (self.fadeOut) {
            if (i == start) {
                [label setType:SBFadeLabelTypeFadeRight];
            } else {
                [label setType:SBFadeLabelTypeFadeAll];
            }
        } else {
            [label setType:SBFadeLabelTypeFadeNone];
        }
    }
    
    self.constraints = [layoutConstraints copy];
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

- (id) initWithTitles:(NSArray*)titles {
    if (self = [super init]) {
        self.fadeOut = YES;
        self.animationDuration = 0.4f;
        self.layer.masksToBounds = YES;
        
        if (titles.count == 0)
            [NSException raise:NSInternalInconsistencyException format:@"initWithTitles: - titles must contain at least 1 NSString"];
        
        NSMutableArray *array = [NSMutableArray array];
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UILabel *label = [[SBFadeLabel alloc] initWithText:title];
            [self addSubview:label];
            [array addObject:label];
        }];
        _labels = [array copy];
        
        self.index = 0;
    }
    return self;
}


- (void) translateToX:(CGFloat)xTranslation {
    CGRect lastLabelFrame = [self.labels.lastObject frame];
    CGRect firstLabelFrame = [self.labels.firstObject frame];
    if (CGRectGetMinX(lastLabelFrame) - xTranslation > CGRectGetMaxX(self.frame)) {
        xTranslation = 0;
    } else if (CGRectGetMaxX(firstLabelFrame) - xTranslation < CGRectGetMinX(self.frame)) {
        xTranslation = 0;
    }
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        CGRect frame = label.frame;
        frame.origin.x -= xTranslation;
        label.frame = frame;
    }];
}

- (void) doneTranslating {
    CGRect centerRect = CGRectMake(self.frame.size.width*.5f-20, 0, 40, self.frame.size.height);
    __block BOOL didSetIndex = NO;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(label.frame, centerRect)) {
            didSetIndex = YES;
            self.index = idx;
        }
    }];
    if (!didSetIndex) {
        CGRect firstLabelFrame = [self.labels.firstObject frame];
        if (firstLabelFrame.origin.x >= centerRect.origin.x)
            self.index = 0;
        else if (firstLabelFrame.origin.x <= centerRect.origin.x)
            self.index = self.labels.count-1;
    }
}

@end
