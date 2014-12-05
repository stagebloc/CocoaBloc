//
//  SCDeviceManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

/**
 * SCDeviceManager manages the specific devices and their settings related to capturing photo or video
 */

#import <Foundation/Foundation.h>
@import AVFoundation;
@import AssetsLibrary;

typedef NS_ENUM(NSUInteger, SBCameraAspectRatio) {
    SBCameraAspectRatio1_1 = 0,
    SBCameraAspectRatio4_3 = 1,
};

@interface SBDeviceManager : NSObject

@property (nonatomic, assign) SBCameraAspectRatio aspectRatio;

@property (nonatomic, readonly, weak) AVCaptureSession *captureSession;
@property (nonatomic, strong, readonly) AVCaptureDeviceInput *currentInput;

@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, readonly, weak) AVCaptureDevice *currentCamera; //gets current camera being used

@property (nonatomic, readonly, weak) AVCaptureDevice *frontFacingCamera;
@property (nonatomic, readonly, weak) AVCaptureDevice *rearCamera;
@property (nonatomic, readonly, weak) AVCaptureDevice *unspecifiedCamera;

@property (nonatomic) CGPoint focusPoint;
@property (nonatomic, assign) AVCaptureExposureMode exposureMode;

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session;

- (void) updateCamera; //updates camera input

@end
