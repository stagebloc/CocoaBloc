//
//  SBCaptionButton.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBCaptionButton.h"
#import "UIFont+FanClub.h"
#import "UIView+Extension.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SBCaptionButton ()
@property (nonatomic, strong) NSArray *constraints;
@property (nonatomic, strong) CALayer *maskLayer;
@end

@implementation SBCaptionButton

- (void) setOn:(BOOL)on {
    [self willChangeValueForKey:@"on"];
    _on = on;
    self.imageView.image = on ? self.onImage : self.offImage;
    [self didChangeValueForKey:@"on"];
}

- (void) initDefaults {
    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.font = [UIFont fc_fontWithSize:12];
    _captionLabel.numberOfLines = 1;
    _captionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_captionLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.startPoint = CGPointMake(0.0f, .5f);
    maskLayer.endPoint = CGPointMake(1.0f, .5f);
    maskLayer.locations =  @[@0, @1];
    UIColor *color = [UIColor colorWithWhite:0 alpha:.7];
    maskLayer.colors = @[(id)color.CGColor, (id)color.CGColor];
    maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.maskLayer = maskLayer;
    
    [self adjustConstraints];
    [self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];

    @weakify(self);
    [[RACSignal combineLatest:@[RACObserve(self, highlighted), RACObserve(self, selected)] reduce:^NSNumber*(NSNumber *highlighted, NSNumber* selected){
        return @(highlighted.boolValue || selected.boolValue);
    }] subscribeNext:^(NSNumber *isSelected) {
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

- (void) pressed {
    self.on = !self.on;
}

#pragma mark - Layout
- (void) layoutSubviews {
    [super layoutSubviews];
    self.maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void) updateConstraints {
    [super updateConstraints];
    [self adjustConstraints];
}

- (void) adjustConstraints {
    [self.constraints autoRemoveConstraints];
    NSMutableArray *constraints = [NSMutableArray array];
    
    CGFloat captionHeight = self.captionLabel.font.pointSize+5;
    [constraints addObject:[self.captionLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self]];
    [constraints addObject:[self.captionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self]];
    [constraints addObject:[self.captionLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self]];
    [constraints addObject:[self.captionLabel autoSetDimension:ALDimensionHeight toSize:captionHeight]];
    
    [constraints addObject:[self.imageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self]];
    [constraints addObject:[self.imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self]];
    [constraints addObject:[self.imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self]];
    [constraints addObject:[self.imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withOffset:-(captionHeight+5)]];
    
    self.constraints = [constraints copy];
}

@end
