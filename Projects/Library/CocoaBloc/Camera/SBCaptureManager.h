//
//  SCCameraManager.h
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class SBVideoManager, SBPhotoManager, SBDeviceManager, RACSignal;

typedef NS_ENUM(NSUInteger, SBCaptureType) {
    SBCaptureTypePhoto = 0,
    SBCaptureTypeVideo = 1,
};

typedef NS_ENUM(NSUInteger, SBCaptureFlashMode) {
    SBCaptureFlashModeOff = 0, //AVCaptureFlashModeOff & AVCaptureTorchModeOff
    SBCaptureFlashModeOn = 1, //AVCaptureFlashModeOn & AVCaptureTorchOn
    SBCaptureFlashModeAuto = 2, //AVCaptureFlashModeAuto & AVCaptureTorchModeAuto
};

/*! 
 This class is responsible for controlling both SBVideoManager & SBPhotoManager to keep them in sync.
 */
@interface SBCaptureManager : NSObject

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong, readonly) SBVideoManager *videoManager;
@property (nonatomic, strong, readonly) SBPhotoManager *photoManager;

@property (nonatomic, assign) SBCaptureType captureType;

@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, assign) SBCaptureFlashMode flashMode;

- (SBDeviceManager*) currentManager;

/*
 Sets the current manager's flash mode to next available mode.
 @return's the next flash mode that was cycled to
 */
- (SBCaptureFlashMode) cycleFlashMode;

- (BOOL) isFocusModeAvailable:(AVCaptureFocusMode)mode;

/*
 Attempts to set the focus mode and point of interest.
 Handles locking/unlocking the currentManager's currentCamera property.
 @return's YES if successful, NO if unsuccessful
 */
- (BOOL) setFocusMode:(AVCaptureFocusMode)mode pointOfInterest:(CGPoint)pointOfInterest;

/*
 RACSignal helper methods
 */
- (RACSignal*) currentManagerChangeSignal;

@end