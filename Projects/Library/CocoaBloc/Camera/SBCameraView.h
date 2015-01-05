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

@class SBProgressBar, SBCaptureView, SBCaptureManager, SBRecordButton, SBPageView, RACSignal;

@interface SBCameraView : UIView <SBBottomViewContrainerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat squareVideoOffsetBottom;

@property (nonatomic, strong) UIView *captureViewContainer;
@property (nonatomic, strong) SBCaptureView *captureView;

@property (nonatomic, strong) SBRecordButton *recordButton;
@property (nonatomic, strong) SBProgressBar *progressBar;
@property (nonatomic, strong) UIToolbar *stateToolbar;

@property (nonatomic, strong) UIView *focusView;

@property (nonatomic, strong) UIView *shutterView;

@property (nonatomic, strong) UIToolbar *topSquareToolbar;
@property (nonatomic, strong) UIToolbar *bottomSquareToolbar;

//Top HUD views
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) SBPageView *pageView;

//Bottom HUD views
@property (nonatomic, strong) UIView *bottomContainerView;
@property (nonatomic, strong) UIButton *chooseExistingButton;
@property (nonatomic, strong) UIButton *optionsMenuButton;
@property (nonatomic, strong) UIButton *nextButton;

//Options menu
@property (nonatomic, strong) SBBottomViewContrainer *optionsMenuContianerView;
@property (nonatomic, strong) UIToolbar *optionsMenuToolbar;
@property (nonatomic, strong) UIButton *toggleRatioButton;
@property (nonatomic, strong) UIButton *toggleCameraButton;
@property (nonatomic, strong) UIButton *flashModeButton;

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
