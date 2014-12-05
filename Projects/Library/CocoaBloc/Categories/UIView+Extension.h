//
//  UIView+Extension.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

/*
 A short cut for the following:
 [self autoCenterInSuperview];
 [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
 [self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview];
 
 @return's NSLayoutConstraints array
 */
- (NSArray*) autoCenterInSuperviewWithMatchedDimensions;

@end


@interface UIView (Screenshot)

//takes screenshot of UIView
- (UIImage*) snapshotImage;

@end