//
//  SCCameraView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPhotoManager.h"

@import AVFoundation.AVCaptureDevice;

@class SCProgressBar, SCCaptureView, SCCaptureManager, SCRecordButton;

@interface SCCameraView : UIView

@property (nonatomic, strong) SCCaptureView *captureView;
@property (nonatomic, strong) SCRecordButton *recordButton;
@property (nonatomic, strong) SCProgressBar *progressBar;
@property (nonatomic, strong) UIToolbar *shutterToolbar;

//Top HUD views
@property (nonatomic, strong) UIView *topHudView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *toggleCameraButton;
@property (nonatomic, strong) UIButton *flashModeButton;
@property (nonatomic, strong) UILabel *timeLabel;

//Bottom HUD views
@property (nonatomic, strong) UIView *bottomHudView;
@property (nonatomic, strong) UIButton *aspectRatioButton;
@property (nonatomic, strong) UIButton *chooseExistingButton;

//Change this property to adjust the flashModeButton image
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

//Change this property to adjust the aspectRatioButton image
@property (nonatomic, assign) SCCameraAspectRatio aspectRatio;

- (instancetype) initWithFrame:(CGRect)frame captureManager:(SCCaptureManager*)captureManager;

/*
 Cycles to the next AVCaptureFlashMode and sets @flashValue
 @return the new cycled value
 */
- (AVCaptureFlashMode) cycleFlashMode;

/*
 Cycles to the next SCCameraAspectRatio and sets @aspectRatio
 @return the new cycled value
 */
- (SCCameraAspectRatio) cycleAspectRatio;

/*
 @return YES if hud is hidden, NO if it is not hidden.
 */
- (BOOL)isHudHidden;

/*
 Animates the hud's alpha value to 0 if hidden = YES
 Animates the hud's alpha value to 1 if hidden = NO
 @param completion is called on animation completion
 */
-(void)animateHudHidden:(BOOL)hidden completion:(void(^)(BOOL finished))completion;
-(void)animateHudHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion;

@end
