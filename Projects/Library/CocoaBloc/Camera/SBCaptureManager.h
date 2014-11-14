//
//  SCCameraManager.h
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

@import AVFoundation.AVCaptureSession;

@class SBVideoManager, SBPhotoManager, SBDeviceManager;

typedef NS_ENUM(NSUInteger, SBCaptureType) {
    SBCaptureTypePhoto = 0,
    SBCaptureTypeVideo = 1,
};

typedef NS_ENUM(NSUInteger, SBCaptureFlashMode) {
    SBCaptureFlashModeOff = 0, //AVCaptureFlashModeOff & AVCaptureTorchModeOff
    SBCaptureFlashModeOn = 1, //AVCaptureFlashModeOn & AVCaptureTorchOn
    SBCaptureFlashModeAuto = 2, //AVCaptureFlashModeAuto & AVCaptureTorchModeAuto
};

@interface SBCaptureManager : NSObject

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong, readonly) SBVideoManager *videoManager;
@property (nonatomic, strong, readonly) SBPhotoManager *photoManager;

@property (nonatomic, assign) SBCaptureType captureType;
@property (nonatomic, assign, readonly) SBCaptureFlashMode flashMode;

- (SBDeviceManager*) currentManager;

@end