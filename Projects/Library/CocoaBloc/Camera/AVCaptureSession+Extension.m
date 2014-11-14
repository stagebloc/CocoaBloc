//
//  AVCaptureSession+Extension.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AVCaptureSession+Extension.h"

@implementation AVCaptureSession (Extension)

- (NSString*) bestSessionPreset {
    if ([self canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        return AVCaptureSessionPreset1920x1080;
    } else if ([self canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        return AVCaptureSessionPreset1280x720;
    } else if ([self canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        return AVCaptureSessionPreset640x480;
    } else if ([self canSetSessionPreset:AVCaptureSessionPreset352x288]) {
        return AVCaptureSessionPreset352x288;
    } else {
        NSLog(@"Cannot set any session preset");
        return nil;
    }
}

- (CGSize) renderSize {
    if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        return CGSizeMake(1920, 1080);
    } else if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        return CGSizeMake(1280, 720);
    } else if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        return CGSizeMake(640, 480);
    } else if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset352x288]) {
        return CGSizeMake(352, 288);
    } else {
        NSLog(@"Cannot find preset");
        return CGSizeZero;
    }
}

- (NSString*) exportPreset {
    if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        return AVAssetExportPreset1920x1080;
    } else if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        return AVAssetExportPreset1280x720;
    } else if ([self.sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        return AVAssetExportPreset640x480;
    } else {
        NSLog(@"Cannot find equal export preset");
        return nil;
    }
}

@end
