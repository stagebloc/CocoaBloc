//
//  SBCaptionButton.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBCaptionButton.h"
#import "UIFont+CocoaBloc.h"
#import "UIView+Extension.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SBCaptionButton ()
@property (nonatomic) NSArray *captionConstraints;
@end

@implementation SBCaptionButton

- (void) setOn:(BOOL)on {
    [self willChangeValueForKey:@"on"];
    _on = on;
    self.imageView.image = on ? self.onImage : self.offImage;
    [self didChangeValueForKey:@"on"];
}

- (void) initDefaults {
    [super initDefaults];
    
    //remove parent class constraints
    [self.imageView.constraints autoRemoveConstraints];
    [self.constraints autoRemoveConstraints];
    
    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.font = [UIFont fc_fontWithSize:12];
    _captionLabel.numberOfLines = 1;
    _captionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_captionLabel];
    
    [self adjustConstraints];
    [self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void) pressed {
    self.on = !self.on;
}

#pragma mark - Layout

- (void) adjustConstraints {
    [self.captionConstraints autoRemoveConstraints];
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
    
    self.captionConstraints = [constraints copy];
}

@end
