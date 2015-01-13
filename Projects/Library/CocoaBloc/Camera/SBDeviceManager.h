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
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, SBCameraAspectRatio) {
    SBCameraAspectRatioSquare = 0,
    SBCameraAspectRatioNormal = 1,
};

/*!
 This is an abstract class that contains shared and boilerplate for SBVideoManager & SBPhotoManager.
 */
@interface SBDeviceManager : NSObject

@property (nonatomic, assign) SBCameraAspectRatio aspectRatio;

@property (nonatomic, readonly, weak) AVCaptureSession *captureSession;
@property (nonatomic, readonly) AVCaptureDeviceInput *currentInput;

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
