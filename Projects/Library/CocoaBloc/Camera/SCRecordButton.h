//
//  SCRecordButton.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCRecordButton;

@protocol SCRecordButtonDelegate <NSObject>
@optional
/*
 Handle TAP state.
 Called when the button is tapped.
 */
- (void) recordButtonTapped:(SCRecordButton*)button;

/*
 Handling of HOLD state.
 Called when button begins to be held.
 */
- (void) recordButtonStartedHolding:(SCRecordButton*)button;

/*
 Handling of HOLD state.
 Called when button stops being held.
 */
- (void) recordButtonStoppedHolding:(SCRecordButton*)button;
@end

@interface SCRecordButton : UIControl

@property (nonatomic, assign) id<SCRecordButtonDelegate> delegate;

/*
 The inner filled view.
 Defaul is a red circle view.
 */
@property (nonatomic, readonly) UIView *innerView;

/*
 How long the user is required to hold the record button for it
 to be considered holding the button.
 
 Default = 0.4f
 */
@property (nonatomic, assign) NSTimeInterval holdingInterval;

@end
