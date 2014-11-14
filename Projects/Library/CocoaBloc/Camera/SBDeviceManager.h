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

@interface SBDeviceManager : NSObject

@property (nonatomic, readonly, weak) AVCaptureSession *captureSession;
@property (nonatomic, readonly) AVCaptureDeviceInput *currentInput;

@property (nonatomic, readonly, weak) AVCaptureDevice *currentCamera;
@property (nonatomic, readonly) AVCaptureDevice *frontFacingCamera;
@property (nonatomic, readonly) AVCaptureDevice *rearCamera;

@property (nonatomic) CGPoint focusPoint;
@property (nonatomic, assign) AVCaptureExposureMode exposureMode;

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session;

@end
