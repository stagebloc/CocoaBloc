//
//  SCCameraManager.m
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCCaptureManager.h"

@interface SCCaptureManager ()

@end

@implementation SCCaptureManager

static SCCaptureManager *_sharedInstance;

+ (SCCaptureManager *) sharedInstance
{
    if (!_sharedInstance)
    {
        _sharedInstance = [[SCCaptureManager alloc] init];
    }
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _captureSession = [AVCaptureSession new];
        
        _photoManager = [[SCPhotoManager alloc] initWithCaptureSession:self.captureSession];
        _videoManager = [[SCVideoManager alloc] initWithCaptureSession:self.captureSession];

        self.captureType = SCCaptureTypeVideo;
        self.currentManager.cameraType = SCCameraTypeRear;
    }
    return self;
}

- (void)setCaptureType:(SCCaptureType)captureType
{
    [self willChangeValueForKey:@"captureType"];
    _captureType = captureType;
    if (_captureType == 0) {
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
            [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        } else {
            if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
                [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
            }
        }
    }
    [self didChangeValueForKey:@"captureType"];
    
    [self.captureSession beginConfiguration];
    // Remove currentManager.currentCamera
    for (AVCaptureDeviceInput *input in self.captureSession.inputs) {
        [self.captureSession removeInput:input];
    }
    [self.captureSession commitConfiguration];

    self.currentManager.cameraType = SCCameraTypeRear;
}

- (SCDeviceManager *)currentManager
{
    return self.captureType == SCCaptureTypePhoto ? self.photoManager : self.videoManager;
}

-(void)setTogglePreset:(AVCaptureSession *)session
{
    _captureSession = session;
    if (session.sessionPreset == AVCaptureSessionPresetHigh) {
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
            _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        } else {
            _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        }
    } else {
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
}


@end
