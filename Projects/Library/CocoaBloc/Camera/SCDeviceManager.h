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

typedef NS_ENUM(NSUInteger, SCCameraType) {
    SCCameraTypeFrontFacing,
    SCCameraTypeRear
};

#import <Foundation/Foundation.h>
@import AVFoundation;
@import AssetsLibrary;

@interface SCDeviceManager : NSObject
- (instancetype)initWithCaptureSession:(AVCaptureSession *)session;
@property (nonatomic, readonly) AVCaptureSession *captureSession;

/**
 * Returns the current device input
 */
@property (nonatomic, readonly) AVCaptureDeviceInput *currentInput;
/**
 * Returns either .frontFacingCamera or .rearCamera, depending on .cameraType
 */
@property (nonatomic, readonly) AVCaptureDevice *currentCamera;
/**
 * Returns an instance of AVCaptureDevice instantiated for the front-facing camera
 */
@property (nonatomic, readonly) AVCaptureDevice *frontFacingCamera;
/**
 * Returns an instance of AVCaptureDevice instantiated for the rear camera
 */
@property (nonatomic, readonly) AVCaptureDevice *rearCamera;
/**
 * Returns the first available camera on a device
 */
@property (nonatomic, readonly) AVCaptureDevice *firstAvailableCamera;
/**
 * The total number of cameras on the device
 */
@property (nonatomic, readonly) NSUInteger numberOfAvailableCameras;
/**
 * The current type of camera being used
 */
@property (nonatomic, assign) SCCameraType cameraType;
/**
 * The mode of focus for the current camera
 */
@property (nonatomic, assign) AVCaptureFocusMode focusMode;
/**
 * Sets the point of focus for the current camera
 */
@property (nonatomic, assign) CGPoint focusPoint;
/**
 * Sets the mode of exposure for the current camera
 */
@property (nonatomic, assign) AVCaptureExposureMode exposureMode;
/**
 * Sets the point of exposure for the current camera
 */
@property (nonatomic, assign) CGPoint exposurePoint;
/**
 * An NSURL pointing to the outputted captured file stored in the app's sandbox-ed temp cache
 * @warning This will return nil unless implemented by subclasses
 */
@property (nonatomic, readonly) NSURL *outputURL;
/**
 * Returns whether or not a specific camera type is available
 */
- (BOOL)hasAvailableCameraType:(SCCameraType)cameraType;

@end
