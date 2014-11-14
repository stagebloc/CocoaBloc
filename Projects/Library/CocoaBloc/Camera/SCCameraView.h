//
//  SCCameraView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPhotoManager.h"
#import "SBCaptureManager.h"

@import AVFoundation.AVCaptureDevice;

@class SCProgressBar, SCCaptureView, SBCaptureManager, SCRecordButton, SCPageView;

@interface SCCameraView : UIView

@property (nonatomic, strong) SCCaptureView *captureView;
@property (nonatomic, strong) SCRecordButton *recordButton;
@property (nonatomic, strong) SCProgressBar *progressBar;
@property (nonatomic, strong) UIToolbar *stateToolbar;

@property (nonatomic, strong) UIView *shutterView;

//Top HUD views
@property (nonatomic, strong) UIView *topHudView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *toggleCameraButton;
@property (nonatomic, strong) UIButton *flashModeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) SCPageView *pageView;

//Bottom HUD views
@property (nonatomic, strong) UIView *bottomHudView;
@property (nonatomic, strong) UIButton *chooseExistingButton;

//Change this property to adjust the flashModeButton image
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

//Change this property to adjust the aspectRatioButton image
//use setPhotoCaptureTypeWithAspectRatio:
@property (nonatomic, assign, readonly) SBCameraAspectRatio aspectRatio;

//change this property to adjust the capture view
//use setPhotoCaptureTypeWithAspectRatio: & setVideoCaptureType
@property (nonatomic, assign, readonly) SBCaptureType captureType;

- (instancetype) initWithFrame:(CGRect)frame captureManager:(SBCaptureManager*)captureManager;

/*
 Cycles to the next AVCaptureFlashMode
 @return the new cycled value
 */
- (AVCaptureFlashMode) cycleFlashMode;

/*
 Cycles to the next SCCameraAspectRatio and sets @aspectRatio
 @return the new cycled value
 */
- (SBCameraAspectRatio) cycleAspectRatio;

/*
 @return YES if hud is hidden, NO if it is not hidden.
 */
- (BOOL)isHudHidden;

- (void) setPhotoCaptureTypeWithAspectRatio:(SBCameraAspectRatio)ratio;
- (void) setVideoCaptureType;

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
