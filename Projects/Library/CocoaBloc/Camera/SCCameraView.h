//
//  SCCameraView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCProgressBar, SCCaptureView, SCCaptureManager, SCRecordButton;

@interface SCCameraView : UIView

@property (nonatomic, strong) SCCaptureView *captureView;
@property (nonatomic, strong) SCRecordButton *recordButton;
@property (nonatomic, strong) SCProgressBar *progressBar;
@property (nonatomic, strong) UIToolbar *shutterToolbar;

//Top HUD views
@property (nonatomic, strong) UIView *topHudView;
@property (nonatomic, strong) UIButton *closeButton;

//Bottom HUD views
@property (nonatomic, strong) UIView *bottomHudView;
@property (nonatomic, strong) UIButton *toggleAspectRatioButton;
@property (nonatomic, strong) UIButton *adjustFlashModeButton;
@property (nonatomic, strong) UIButton *toggleCameraButton;
@property (nonatomic, strong) UIButton *chooseExistingButton;

- (instancetype) initWithFrame:(CGRect)frame captureManager:(SCCaptureManager*)captureManager;

- (BOOL)isHudHidden;

-(void)animateHudHidden:(BOOL)hidden completion:(void(^)(BOOL finished))completion;
-(void)animateHudHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion;

@end
