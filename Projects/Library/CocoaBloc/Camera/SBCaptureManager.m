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
#import "NSUserDefaults+Camera.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AVCaptureSession+Extension.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface SBCaptureManager ()

@end

@implementation SBCaptureManager

- (void) setDevicePosition:(AVCaptureDevicePosition)devicePosition {
    [self willChangeValueForKey:@"devicePosition"];
    _devicePosition = devicePosition;
    
    self.videoManager.devicePosition = devicePosition;
    self.photoManager.devicePosition = devicePosition;
    [self setCaptureType:self.captureType];
    [self didChangeValueForKey:@"devicePosition"];
    
    [NSUserDefaults setDevicePosition:devicePosition];
}

- (void) setFlashMode:(SBCaptureFlashMode)flashMode {
    BOOL didSet = NO;
    AVCaptureDevice *input = self.currentManager.currentCamera;
    [input lockForConfiguration:nil];
    if (self.captureType == SBCaptureTypePhoto) {
        AVCaptureFlashMode mode = (AVCaptureFlashMode) flashMode;
        if ([input isFlashModeSupported:mode]) {
            input.flashMode = mode;
            didSet = YES;
        }
    } else {
        AVCaptureTorchMode mode = (AVCaptureTorchMode) flashMode;
        if ([input isTorchModeSupported:mode]) {
            input.torchMode = mode;
            didSet = YES;
        }
    }
    [input unlockForConfiguration];
    
    [self willChangeValueForKey:@"flashMode"];
    if (didSet) _flashMode = flashMode;
    else _flashMode = SBCaptureFlashModeOff;
    [self didChangeValueForKey:@"flashMode"];
}

- (void) setCaptureType:(SBCaptureType)captureType {
    switch (captureType) {
        case SBCaptureTypePhoto:
            if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto])
                self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
            break;
        case SBCaptureTypeVideo: {
            NSString *preset = AVCaptureSessionPresetHigh;
            if ([self.captureSession canSetSessionPreset:preset])
                self.captureSession.sessionPreset = preset;
            }
            break;
        default: break;
    }
    _captureType = captureType;
    [self setFlashMode:SBCaptureFlashModeOff];
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
        self.devicePosition = [NSUserDefaults devicePosition];
    }
    return self;
}
    
- (SBDeviceManager*) currentManager {
    return self.captureType == SBCaptureTypePhoto ? self.photoManager : self.videoManager;
}

- (SBCaptureFlashMode) nextFlashMode:(SBCaptureFlashMode)fromMode {
    switch (fromMode) {
        case SBCaptureFlashModeOff: return SBCaptureFlashModeOn;
        case SBCaptureFlashModeOn: return SBCaptureFlashModeAuto;
        default: return SBCaptureFlashModeOff;
    }
}

- (SBCaptureFlashMode) cycleFlashMode {
    SBCaptureFlashMode current = self.flashMode;
    SBCaptureFlashMode nextMode = current;
    do {
        nextMode = [self nextFlashMode:nextMode];
        [self setFlashMode:nextMode];
        if (self.flashMode == nextMode)
            break;
    } while (current != nextMode);
    return nextMode;
}

- (BOOL) isFocusModeAvailable:(AVCaptureFocusMode)mode {
    AVCaptureDevice *device = self.currentManager.currentCamera;
    return [device isFocusModeSupported:mode];
}

- (BOOL) setFocusMode:(AVCaptureFocusMode)mode pointOfInterest:(CGPoint)pointOfInterest {
    AVCaptureDevice *device = self.currentManager.currentCamera;
    if ([device isFocusModeSupported:mode] && [device isFocusPointOfInterestSupported]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:pointOfInterest];
            [device setFocusMode:mode];
            [device unlockForConfiguration];
            return YES;
        } else {
            NSLog(@"Error: %@", error);
        }
    }
    return NO;
}

#pragma mark - RACSignals
- (RACSignal*) currentManagerChangeSignal {
    @weakify(self);
    RACSignal *signal = [[RACObserve(self, captureType) skip:1] map:^SBDeviceManager*(NSNumber *n) {
        @strongify(self);
        return self.currentManager;
    }];
    return signal;
}

@end
