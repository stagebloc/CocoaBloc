//
//  SBImageControl.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBImageControl.h"
#import "UIView+Extension.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation SBImageControl

- (void) initDefaults {
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    [self.imageView autoCenterInSuperviewWithMatchedDimensions];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.startPoint = CGPointMake(0.0f, .5f);
    maskLayer.endPoint = CGPointMake(1.0f, .5f);
    maskLayer.locations =  @[@0, @1];
    UIColor *color = [UIColor colorWithWhite:0 alpha:.7];
    maskLayer.colors = @[(id)color.CGColor, (id)color.CGColor];
    maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.maskLayer = maskLayer;
    
    @weakify(self);
    [[RACSignal combineLatest:@[RACObserve(self, highlighted), RACObserve(self, selected)] reduce:^NSNumber*(NSNumber *highlighted, NSNumber* selected){
        return @(highlighted.boolValue || selected.boolValue);
    }] subscribeNext:^(NSNumber *isSelected) {
        @strongify(self);
        BOOL selected = isSelected.boolValue;
        if (selected) {
            self.layer.mask = self.maskLayer;
        } else {
            self.layer.mask = nil;
        }
    }];
}

- (instancetype) init {
    if (self = [super init]) {
        [self initDefaults];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaults];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaults];
    }
    return self;
}

#pragma mark - Layout
- (void) layoutSubviews {
    [super layoutSubviews];
    self.maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
