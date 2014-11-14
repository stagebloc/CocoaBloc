//
//  SCCameraManager.m
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBCaptureManager.h"
#import "SBVideoManager.h"
#import "SBPhotoManager.h"

@interface SBCaptureManager ()

@end

@implementation SBCaptureManager

//@return's YES if successful
- (BOOL) setFlashMode:(SBCaptureFlashMode)flashMode {
    AVCaptureDevice *input = self.currentManager.currentCamera;
    [input lockForConfiguration:nil];
    if (self.captureType == SBCaptureTypePhoto) {
        AVCaptureFlashMode mode = (AVCaptureFlashMode) flashMode;
        if ([input isFlashModeSupported:mode]) {
            input.flashMode = mode;
        } else {
            [input unlockForConfiguration];
            return NO;
        }
    } else {
        AVCaptureTorchMode mode = (AVCaptureTorchMode) flashMode;
        if ([input isTorchModeSupported:mode]) {
            input.torchMode = mode;
        } else {
            [input unlockForConfiguration];
            return NO;
        }
    }
    [input unlockForConfiguration];
    
    [self willChangeValueForKey:@"flashMode"];
    _flashMode = flashMode;
    [self didChangeValueForKey:@"flashMode"];
    
    return YES;
}

- (void) setCaptureType:(SBCaptureType)captureType {
    switch (captureType) {
        case SBCaptureTypePhoto:
//            [self.videoManager.currentCamera stopCameraCapture];
//            [self.photoManager.currentCamera startCameraCapture];
            break;
        case SBCaptureTypeVideo:
//            [self.photoManager.camera stopCameraCapture];
//            [self.videoManager.camera startCameraCapture];
            break;
        default: break;
    }
    _captureType = captureType;
    self.flashMode = SBCaptureFlashModeOff;
}

- (instancetype) init {
    return [self initWithSession:[[AVCaptureSession alloc] init]];
}

- (instancetype) initWithSession:(AVCaptureSession*) captureSession {
    if (self = [super init]) {
        self.captureSession = captureSession;

        _videoManager = [[SBVideoManager alloc] initWithCaptureSession:captureSession];
        _photoManager = [[SBPhotoManager alloc] initWithCaptureSession:captureSession];
        self.captureType = self.captureType;
    }
    return self;
}
    
- (SBDeviceManager*) currentManager {
    return self.captureType == SBCaptureTypePhoto ? self.photoManager : self.videoManager;
}

- (void) cycleFlashMode {
    //bad logic
    //    int max = self.flashMode + SBCaptureFlashModeMax;
    //    for (int m = self.flashMode; m < max; m++) {
    //        SBCaptureFlashMode mode = max - m;
    //        if ([self setFlashMode:mode])
    //            break;
    //    }
}

@end
