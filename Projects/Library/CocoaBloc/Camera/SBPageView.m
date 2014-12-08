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

- (CGFloat) alphaForCharPosition:(int)pos reverse:(BOOL)isReversed{
    CGFloat toReturn = 0;
    int const Max = 5.0;
    CGFloat const MaxDiv = Max+2;
    if (pos <= Max)
        toReturn = (pos / (MaxDiv));
    
    if (isReversed) {
        CGFloat const Reverse = Max / MaxDiv;
        toReturn = Reverse - toReturn;
    }
    
    return toReturn;
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
    
    UILabel *baseLabel = self.labels[self.index];
    baseLabel.textColor = [self.selectedColor copy];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    NSMutableAttributedString *baseString = [baseLabel.attributedText mutableCopy];
    [baseString removeAllAttributes];
    baseLabel.attributedText = baseString;
    
    //left of base label
    long start = self.index-1;
    for (long i = start; i >= 0; i--) {
        UILabel *pinLabel = i == start ? baseLabel : self.labels[i+1];
        UILabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:pinLabel withOffset:-Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        NSMutableAttributedString *attrString = [label.attributedText mutableCopy];
        [attrString removeAllAttributes];
        if (self.fadeOut) {
            NSUInteger len = attrString.length;
            if (i == start) {
                for (int i = 0; i < len; i++) {
                    CGFloat alpha = [self alphaForCharPosition:i reverse:NO];
                    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:alpha] range:NSMakeRange(i, 1)];
                }
            } else {
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:0] range:NSMakeRange(0, len)];
            }
            label.attributedText = attrString;
        }
    }
    //right of base label
    start = self.index+1;
    for (long i = start; i < count; i++) {
        UILabel *pinLabel = i == start ? baseLabel : self.labels[i-1];
        UILabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pinLabel withOffset:Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        NSMutableAttributedString *attrString = [label.attributedText mutableCopy];
        [attrString removeAllAttributes];
        if (self.fadeOut) {
            NSUInteger len = attrString.length;
            if (i == start) {
                for (int i = 0; i < len; i++) {
                    CGFloat alpha = [self alphaForCharPosition:i reverse:YES];
                    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:alpha] range:NSMakeRange(i, 1)];
                }
            } else {
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:0] range:NSMakeRange(0, len)];
            }
            label.attributedText = attrString;
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
            UILabel *label = [self createLabelWithTitle:[[NSAttributedString alloc] initWithString:title]];
            [self addSubview:label];
            [array addObject:label];
        }];
        _labels = [array copy];
        
        self.index = 0;
    }
    return self;
}

- (UILabel*) createLabelWithTitle:(NSAttributedString*)title{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = title;
    label.numberOfLines = 1;
    [label sizeToFit];
    return label;
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
