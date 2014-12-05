//
//  UIView+AutoLayout.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIView+AutoLayout.h"
#import <PureLayout/PureLayout.h>

@implementation UIView (AutoLayout)

/*
 A short cut for the following:
 [self autoCenterInSuperview];
 [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
 [self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview];
 
 @return's NSLayoutConstraints array
 */
- (NSArray*) autoCenterInSuperviewWithMatchedDimensions {
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[self autoCenterInSuperview]];
    [constraints addObject:[self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview]];
    [constraints addObject:[self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview]];
    return [constraints copy];
}

@end
