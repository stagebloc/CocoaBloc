//
//  SCPageView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/7/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SCPageView.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+FanClub.h"

@interface SCPageView ()

@property (nonatomic, strong) NSArray *constraints;

@end

@implementation SCPageView

- (UIColor*) selectedColor {
    if (!_selectedColor)
        _selectedColor = [UIColor fc_stageblocBlueColor];
    return _selectedColor;
}
- (UIColor*) deselectedColor {
    if (!_deselectedColor)
        _deselectedColor = [UIColor whiteColor];
    return _deselectedColor;
}

- (void) setIndex:(NSInteger)index {
    [self willChangeValueForKey:@"index"];
    if (index < 0) index = 0;
    if (index >= self.labels.count) index = self.labels.count - 1;
    
    _index = index;
    [self configureLayout];
    
    [self didChangeValueForKey:@"index"];
}

- (void) configureLayout {
    [self.constraints autoRemoveConstraints];

    CGFloat const Padding = 15;
    NSUInteger count = self.labels.count;
    
    NSMutableArray *layoutConstraints = [NSMutableArray array];

    UILabel *baseLabel = self.labels[self.index];
    baseLabel.textColor = [self.selectedColor copy];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [layoutConstraints addObject:[baseLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    
    //left of base label
    int start = self.index-1;
    for (int i = start; i >= 0; i--) {
        UILabel *pinLabel = i == start ? baseLabel : self.labels[i+1];
        UILabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:pinLabel withOffset:-Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    //right of base label
    start = self.index+1;
    for (int i = start; i < count; i++) {
        UILabel *pinLabel = i == start ? baseLabel : self.labels[i-1];
        UILabel *label = self.labels[i];
        label.textColor = [self.deselectedColor copy];
        [layoutConstraints addObject:[label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pinLabel withOffset:Padding]];
        [layoutConstraints addObject:[label autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    
    self.constraints = [layoutConstraints copy];

    [UIView animateWithDuration:self.animationDuration animations:^{
        [self layoutIfNeeded];
    }];
}

- (id) initWithTitles:(NSArray*)titles {
    if (self = [super init]) {
        self.animationDuration = 0.4f;
        self.layer.masksToBounds = YES;

        if (titles.count == 0)
            [NSException raise:NSInternalInconsistencyException format:@"initWithTitles: - titles must contain at least 1 NSString"];
        
        NSMutableArray *array = [NSMutableArray array];
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UILabel *label = [self createLabelWithTitle:title];
            [self addSubview:label];
            [array addObject:label];
        }];
        _labels = [array copy];
        
        self.index = 0;
    }
    return self;
}

- (UILabel*) createLabelWithTitle:(NSString*)title{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.numberOfLines = 1;
    [label sizeToFit];
    return label;
}

@end
