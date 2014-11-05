//
//  SCCameraView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCProgressBar, SCCaptureView, SCCaptureManager;

@interface SCCameraView : UIView

@property (nonatomic, strong) SCCaptureView *captureView;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *chooseExistingButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UISwitch *toggleSwitch;

@property (nonatomic, strong) UIView *topOverlayView;
@property (nonatomic, strong) UIView *bottomOverlayView;

@property (nonatomic, strong) UIToolbar *shutterToolbar;

@property (nonatomic, strong) SCProgressBar *progressBar;

//toolbar
@property UIToolbar *toolbar;
@property BOOL toolBarExpanded;
@property (nonatomic, strong) UIButton *toggleAspectRatioButton;
@property (nonatomic, strong) UIButton *adjustFlashModeButton;
@property (nonatomic, strong) UIButton *toggleCameraButton;
//

- (id) initWithFrame:(CGRect)frame captureManager:(SCCaptureManager*)captureManager;

- (BOOL) isHudHidden;

-(void)animateHudHidden:(BOOL)hidden completion:(void(^)(BOOL finished))completion;
-(void)animateHudHidden:(BOOL)hidden duration:(CGFloat)duration completion:(void(^)(BOOL finished))completion;

@end
