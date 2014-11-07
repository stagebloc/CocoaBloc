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
    
    NSString *preset = AVCaptureSessionPresetHigh;
    if (_captureType == SCCaptureTypePhoto) {
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
            preset = AVCaptureSessionPresetPhoto;
        }
    }
    
    if (![preset isEqualToString:self.captureSession.sessionPreset])
        self.captureSession.sessionPreset = preset;
    
    [self didChangeValueForKey:@"captureType"];
    self.currentManager.cameraType = SCCameraTypeRear;
}

- (SCDeviceManager *)currentManager {
    return self.captureType == SCCaptureTypePhoto ? self.photoManager : self.videoManager;
}

@end
