//
//  SBDraggableView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBDraggableView, RACSignal;

typedef NS_OPTIONS(NSUInteger, SBDraggableViewDirection) {
    SBDraggableViewDirectionNone = (1 << 0),
    SBDraggableViewDirectionUpDown = (1 << 1),
    SBDraggableViewDirectionLeftRight = (1 << 2),
};

@protocol SBDraggableViewDelegate <NSObject>
@optional
- (void) draggableViewDidStopMoving:(SBDraggableView*)view velocity:(CGPoint)velocity;
- (void) draggableViewDidMove:(SBDraggableView*)view;
@end

@interface SBDraggableView : UIView

@property (nonatomic) SBDraggableViewDirection dragDirection;
@property (nonatomic, weak) id <SBDraggableViewDelegate> dragDelegate;

/*
 The following attributes are optional and a nil value indicates
 that there is no restriction.
 */
@property (nonatomic) NSNumber *leftRestriction; //(x) won't go past this value
@property (nonatomic) NSNumber *rightRestriction; //(x + width) won't go past this value
@property (nonatomic) NSNumber *topRestriction; //(y) won't go past this value
@property (nonatomic) NSNumber *bottomRestriction; //(y + height) won't go past this value

- (void) initDefaults;

@end

@interface SBDraggableView (Subclassing)

//same as delegate calls
- (void) moved;
- (void) stoppedMovingWithVelocity:(CGPoint)velocity;

@end