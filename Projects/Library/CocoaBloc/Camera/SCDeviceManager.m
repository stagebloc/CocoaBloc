//
//  SCDeviceManager.m
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCDeviceManager.h"

@implementation SCDeviceManager

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session
{
    self = [super init];
    if (self) {
        _captureSession = session;
        
        self.cameraType = SCCameraTypeRear;
    }
    return self;
}

- (AVCaptureDevice *)frontFacingCamera
{
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == AVCaptureDevicePositionFront) {
            return d;
        }
    }
    return nil;
}

- (AVCaptureDevice *)rearCamera
{
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == AVCaptureDevicePositionBack) {
            return d;
        }
    }
    return nil;
}

- (AVCaptureDevice *)firstAvailableCamera
{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (NSUInteger)numberOfAvailableCameras
{
    NSUInteger num = 0;
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position != AVCaptureDevicePositionUnspecified) {
            num++;
        }
    }
    return num;
}

- (void)setFocusMode:(AVCaptureFocusMode)focusMode
{
    NSError *error = nil;
    [self.currentCamera lockForConfiguration:&error];
    if (error) {
        
    } else {
        if ([self.currentCamera isFocusModeSupported:focusMode]) {
            self.currentCamera.focusMode = focusMode;
        }
        [self.currentCamera unlockForConfiguration];
    }
}

- (void)setFocusPoint:(CGPoint)focusPoint
{
    NSAssert(focusPoint.x >= 0.f && focusPoint.x <= 1.f, @"Focus point x must be between 0 and 1 (inclusive)");
    NSAssert(focusPoint.y >= 0.f && focusPoint.y <= 1.f, @"Focus point y must be between 0 and 1 (inclusive)");
    if ([self.currentCamera isFocusPointOfInterestSupported]) {
        NSError *error = nil;
        [self.currentCamera lockForConfiguration:&error];
        if (error) {
            
        } else {
            self.currentCamera.focusPointOfInterest = focusPoint;
            [self.currentCamera unlockForConfiguration];
        }
    }
}

- (void)setExposureMode:(AVCaptureExposureMode)exposureMode
{
    if ([self.currentCamera isExposureModeSupported:exposureMode]) {
        NSError *error = nil;
        [self.currentCamera lockForConfiguration:&error];
        if (error) {
            // TODO: Appropriate error handling here
        } else {
            self.currentCamera.exposureMode = exposureMode;
            [self.currentCamera unlockForConfiguration];
        }
    }
}

- (void)setExposurePoint:(CGPoint)exposurePoint
{
    NSAssert(exposurePoint.x >= 0.f && exposurePoint.x <= 1.f, @"Exposure point x must be between 0 and 1 (inclusive)");
    NSAssert(exposurePoint.y >= 0.f && exposurePoint.y <= 1.f, @"Exposure point y must be between 0 and 1 (inclusive)");
    if ([self.currentCamera isExposurePointOfInterestSupported]) {
        NSError *error = nil;
        [self.currentCamera lockForConfiguration:&error];
        if (error) {
            
        } else {
            self.currentCamera.exposurePointOfInterest = exposurePoint;
            [self.currentCamera unlockForConfiguration];
        }
    }
}

- (void) setFlashMode:(AVCaptureFlashMode)flashMode {
    self.currentCamera.flashMode = flashMode;
}
- (AVCaptureFlashMode) flashMode {
    return self.currentCamera.flashMode;
}

- (BOOL)isFlashModeAvailable:(AVCaptureFlashMode)flashMode {
    return [self.currentCamera isFlashModeSupported:flashMode];
}

- (BOOL)hasAvailableCameraType:(SCCameraType)cameraType
{
    // Can we cache this response, or improve it somehow?
    return cameraType == SCCameraTypeFrontFacing ? (self.frontFacingCamera != nil) : (self.rearCamera != nil);
}

- (void)setCameraType:(SCCameraType)cameraType
{
    [self willChangeValueForKey:@"cameraType"];
    _cameraType = cameraType;
    [self didChangeValueForKey:@"cameraType"];
    
    AVCaptureDevice *device = _cameraType == SCCameraTypeFrontFacing ? self.frontFacingCamera : self.rearCamera;
    if (_currentCamera != device) {
        // Add currentManager.currentCamera
        // If video, add microphone as well
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:_currentInput];
        
        NSError *error = nil;
        _currentInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {
            // Appropriately handle error here
        } else {
            if ([self.captureSession canAddInput:_currentInput]) {
                [self.captureSession addInput:_currentInput];
            }
            [self.captureSession commitConfiguration];
        }
    }
    _currentCamera = device;

}

@end
