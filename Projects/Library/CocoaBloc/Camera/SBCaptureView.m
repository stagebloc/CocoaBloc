//
//  SCPreviewView.m
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBCaptureView.h"
#import "UIDevice+Orientation.h"

@import AVFoundation.AVCaptureVideoPreviewLayer;

@implementation SBCaptureView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoPreviewLayer*) captureLayer {
    return ((AVCaptureVideoPreviewLayer *)self.layer);
}

- (AVCaptureSession *)captureSession {
    return self.captureLayer.session;
}

- (void) updateVideoConnectionWithOrientation:(AVCaptureVideoOrientation)orientation {
    AVCaptureConnection *previewLayerConnection = self.captureLayer.connection;
    if ([previewLayerConnection isVideoOrientationSupported])
        [previewLayerConnection setVideoOrientation:orientation];
}

- (instancetype) initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super init]) {
        [self addSessionIfNeeded:session];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            
            AVCaptureVideoOrientation orientation = [[UIDevice currentDevice] videoOrientation];
            if ((NSInteger)orientation != -1) {
                [self updateVideoConnectionWithOrientation:orientation];
            }
        }];
    }
    return self;
}

- (void) addSessionIfNeeded:(AVCaptureSession*)session {
    if (self.captureLayer.session == session)
        return;
    self.captureLayer.session = nil;
    self.captureLayer.session = session;
}

- (void) removeSession {
    self.captureLayer.session = nil;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
