//
//  SCDeviceManager.m
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBDeviceManager.h"

@implementation SBDeviceManager

- (void) setDevicePosition:(AVCaptureDevicePosition)devicePosition {
    [self willChangeValueForKey:@"devicePosition"];
    _devicePosition = devicePosition;
    [self didChangeValueForKey:@"devicePosition"];
    
    [self updateCamera];
}

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super init]) {
        _captureSession = session;
        _aspectRatio = SBCameraAspectRatio4_3;
        [self updateCamera];
    }
    return self;
}

- (void) updateCamera {
    if (self.currentInput) {
        [self.captureSession removeInput:self.currentInput];
        _currentInput = nil;
    }
    
    NSError *error = nil;
    AVCaptureDevice *captureDevice = self.currentCamera;
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if([self.captureSession canAddInput:input]) {
        _currentInput = input;
        [self.captureSession addInput:self.currentInput];
    } else {
        NSLog(@"Error setting input to capture session - %@", error.localizedDescription);
    }
}

- (AVCaptureDevice *) currentCamera {
    switch (self.devicePosition) {
        case AVCaptureDevicePositionFront:
            return self.frontFacingCamera;
        case AVCaptureDevicePositionBack:
            return self.rearCamera;
        default:
            return self.unspecifiedCamera;
    }
}

- (AVCaptureDevice *)frontFacingCamera {
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == AVCaptureDevicePositionFront)
            return d;
    }
    return nil;
}

- (AVCaptureDevice *)rearCamera {
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == AVCaptureDevicePositionBack)
            return d;
    }
    return nil;
}

- (AVCaptureDevice *)unspecifiedCamera {
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == AVCaptureDevicePositionUnspecified)
            return d;
    }
    return nil;
}

- (void)setFocusPoint:(CGPoint)focusPoint {
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

- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
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

- (void)setExposurePoint:(CGPoint)exposurePoint {
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

@end
