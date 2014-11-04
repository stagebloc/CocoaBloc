//
//  SCPreviewView.m
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCCaptureView.h"

@import AVFoundation.AVCaptureVideoPreviewLayer;

@implementation SCCaptureView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session
{
    self = [super init];
    if (self) {
        ((AVCaptureVideoPreviewLayer *)self.layer).session = session;
    }
    return self;
}

- (AVCaptureSession *)captureSession
{
    return ((AVCaptureVideoPreviewLayer *)self.layer).session;
}

@end
