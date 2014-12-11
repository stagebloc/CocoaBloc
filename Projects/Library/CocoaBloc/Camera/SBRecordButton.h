//
//  SCRecordButton.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBRecordButton;

typedef NS_ENUM(NSUInteger, SBRecordButtonState) {
    SBRecordButtonStateNone = 0,
    SBRecordButtonStateHolding,
};

@protocol SCRecordButtonDelegate <NSObject>
@optional
/*
 Handle TAP state.
 Called when the button is tapped.
 */
- (void) recordButtonTapped:(SBRecordButton*)button;

/*
 Handling of HOLD state.
 Called when button begins to be held.
 */
- (void) recordButtonStartedHolding:(SBRecordButton*)button;

/*
 Handling of HOLD state.
 Called when button stops being held.
 */
- (void) recordButtonStoppedHolding:(SBRecordButton*)button;
@end

@interface SBRecordButton : UIControl

@property (nonatomic, strong) NSLayoutConstraint *centerConstraint;

@property (nonatomic, assign) BOOL holding;

@property (nonatomic, assign) id<SCRecordButtonDelegate> delegate;

/*
 The inner filled view.
 Defaul is a fc_stageblocBlueColor bordered view.
 */
@property (nonatomic, readonly) UIView *innerView;

/*
 How long the user is required to hold the record button for it
 to be considered holding the button.
 
 Default = 0.4f
 */
@property (nonatomic, assign) NSTimeInterval holdingInterval;

/*
 Set this property to YES if you want holding to be interpreted
 Otherwise set to NO to allow for only presses.
 
 Default = YES
 */
@property (nonatomic, assign) BOOL allowHold;

/*
 Border color ring for button
 */
- (void) setBorderColor:(UIColor*)borderColor;

- (NSLayoutConstraint*) autoAlignVerticalAxisToSuperview;

@end
