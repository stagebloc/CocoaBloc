//
//  SBDraggableView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBDraggableView;

typedef NS_OPTIONS(NSUInteger, SBDraggableViewDirection) {
    SBDraggableViewDirectionNone = (1 << 0),
    SBDraggableViewDirectionUpDown = (1 << 2),
    SBDraggableViewDirectionLeftRight = (1 << 3),
};

@protocol SBDraggableViewDelegate <NSObject>
@optional
- (void) draggableViewDidStopMoving:(SBDraggableView*)view;
- (void) draggableViewDidMove:(SBDraggableView*)view;
- (void) draggableViewTapped:(SBDraggableView*)view event:(UIEvent*)event;
@end

@interface SBDraggableView : UIView

@property (nonatomic) SBDraggableViewDirection dragDirection;
@property (nonatomic) id <SBDraggableViewDelegate> dragDelegate;

/*
 * The following attributes do not need to be set and are nil by default
 * nil means there are no restrictions
 */
@property (nonatomic) NSNumber *leftRestriction; //left (x) won't go past this value
@property (nonatomic) NSNumber *rightRestriction; //right (x + width) won't go past this value
@property (nonatomic) NSNumber *topRestriction; //top (y) won't go past this value
@property (nonatomic) NSNumber *bottomRestriction; //bottom (y + height) won't go past this value

@end