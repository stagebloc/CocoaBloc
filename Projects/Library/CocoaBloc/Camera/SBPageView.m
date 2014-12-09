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
    
    UILabel *baseLabel = self.labels[self.index];
    baseLabel.textColor = [self.selectedColor copy];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    
    //left of base label
    long start = self.index-1;
    for (long i = start; i >= 0; i--) {
        UILabel *pinLabel = i == start ? baseLabel : self.labels[i+1];
        UILabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:pinLabel withOffset:-Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    //right of base label
    start = self.index+1;
    for (long i = start; i < count; i++) {
        UILabel *pinLabel = i == start ? baseLabel : self.labels[i-1];
        UILabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pinLabel withOffset:Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
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
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            [self addSubview:label];
            [array addObject:label];
        }];
        _labels = [array copy];
        
        self.index = 0;
        

        //layer mask
        UIColor *hideColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        UIColor *halfColor = [UIColor colorWithWhite:1.0 alpha:0.3f];
        UIColor *showColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.anchorPoint = CGPointZero;
        maskLayer.startPoint = CGPointMake(0.0f, .5f);
        maskLayer.endPoint = CGPointMake(1.0f, .5f);
        maskLayer.locations =  @[@0, @.2f, @.35f, @0.65f, @.8f, @1.0f];;
        
        maskLayer.colors = @[(id)hideColor.CGColor, (id)halfColor.CGColor, (id)showColor.CGColor, (id)showColor.CGColor, (id)halfColor.CGColor, (id)hideColor.CGColor];;
        maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.layer.mask.bounds = bounds;
}

@end
