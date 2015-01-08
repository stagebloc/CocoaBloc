//
//  SCCameraView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SBPhotoManager.h"
#import "SBCaptureManager.h"
#import "SBBottomViewContrainer.h"

@class SBProgressBar, SBCaptureView, SBCaptureManager, SBRecordButton, SBPageView, RACSignal, SBOptionsChevronButton;

@interface SBCameraView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat squareVideoOffsetBottom;

@property (nonatomic) UIView *captureViewContainer;
@property (nonatomic) SBCaptureView *captureView;

@property (nonatomic) SBRecordButton *recordButton;
@property (nonatomic) SBProgressBar *progressBar;
@property (nonatomic) UIToolbar *stateToolbar;

@property (nonatomic) UIView *focusView;

@property (nonatomic) UIView *shutterView;

@property (nonatomic) UIToolbar *topSquareToolbar;
@property (nonatomic) UIToolbar *bottomSquareToolbar;

//Top HUD views
@property (nonatomic) UIView *topContainerView;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) SBPageView *pageView;

//Bottom HUD views
@property (nonatomic) UIView *bottomContainerView;
@property (nonatomic) UIButton *chooseExistingButton;
@property (nonatomic) SBOptionsChevronButton *optionsMenuButton;
@property (nonatomic) UIButton *nextButton;

//Options menu
@property (nonatomic) SBBottomViewContrainer *optionsMenuContianerView;
@property (nonatomic) UIButton *toggleRatioButton;
@property (nonatomic) UIButton *toggleCameraButton;
@property (nonatomic) UIButton *flashModeButton;

//Change this property to adjust the flashModeButton image
@property (nonatomic, assign) SBCaptureFlashMode flashMode;

//Change this property to adjust the aspectRatioButton image
//use setPhotoCaptureTypeWithAspectRatio:
@property (nonatomic, assign) SBCameraAspectRatio aspectRatio;

//change this property to adjust the capture view
//use setPhotoCaptureTypeWithAspectRatio: & setVideoCaptureType
@property (nonatomic, assign, readonly) SBCaptureType captureType;

@property (nonatomic, copy) BOOL (^shouldUpdateFocusPosition)(CGPoint toPosition);

- (instancetype) initWithFrame:(CGRect)frame captureManager:(SBCaptureManager*)captureManager;

/*
 @return YES if hud is hidden, NO if it is not hidden.
 */
- (BOOL)isHudHidden;

- (void) setPhotoCaptureTypeWithAspectRatio:(SBCameraAspectRatio)ratio;
- (void) setVideoCaptureTypeWithAspectRatio:(SBCameraAspectRatio)ratio;

- (RACSignal*) focusPointChangeSignal;
- (RACSignal*) doubleTapSignal;
- (RACSignal*) swipeLeftSignal;
- (RACSignal*) swipeRightSignal;

/*
 Animates the hud's alpha value to 0 if hidden = YES
 Animates the hud's alpha value to 1 if hidden = NO
 @param completion is called on animation completion
 */
-(void)animateHudHidden:(BOOL)hidden completion:(void(^)(BOOL finished))completion;
-(void)animateHudHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion;

-(void)animateShutter:(void(^)(BOOL finished))completion;
-(void)animateShutterWithDuration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion;

@end
