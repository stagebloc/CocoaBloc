//
//  AVCaptureSession+Extension.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AVCaptureSession+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation AVCaptureSession (Extension)

+ (CGSize) size:(CGSize)size fromOrientation:(AVCaptureVideoOrientation)orientation {
    if(orientation == AVCaptureVideoOrientationPortrait || orientation == AVCaptureVideoOrientationPortraitUpsideDown)
        return CGSizeMake(size.height, size.width);
    return size;
}

- (NSString*) bestSessionPreset {
    if ([self canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        return AVCaptureSessionPreset1920x1080;
    } else if ([self canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        return AVCaptureSessionPreset1280x720;
    } else if ([self canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        return AVCaptureSessionPreset640x480;
    } else if ([self canSetSessionPreset:AVCaptureSessionPreset352x288]) {
        return AVCaptureSessionPreset352x288;
    }
    
    NSLog(@"Cannot set any session preset");
    return nil;
}

- (CGSize) renderSize {
    return [AVCaptureSession renderSizeForSessionPreset:self.sessionPreset];
}

+ (CGSize) renderSizeForSessionPreset:(NSString*)preset {
    if ([preset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        return CGSizeMake(1920, 1080);
    } else if ([preset isEqualToString:AVCaptureSessionPreset1280x720]) {
        return CGSizeMake(1280, 720);
    } else if ([preset isEqualToString:AVCaptureSessionPreset640x480]) {
        return CGSizeMake(640, 480);
    } else if ([preset isEqualToString:AVCaptureSessionPreset352x288]) {
        return CGSizeMake(352, 288);
    } else {
        NSLog(@"Cannot find preset");
        return CGSizeZero;
    }
}

+ (CGSize) renderSizeForExportPreset:(NSString*)preset {
    if ([preset isEqualToString:AVAssetExportPreset1920x1080]) {
        return CGSizeMake(1920, 1080);
    } else if ([preset isEqualToString:AVAssetExportPreset1280x720]) {
        return CGSizeMake(1280, 720);
    } else if ([preset isEqualToString:AVAssetExportPreset640x480]) {
        return CGSizeMake(640, 480);
    } else {
        NSLog(@"Cannot find preset");
        return CGSizeZero;
    }
}

- (NSString*) exportPreset {
    return [AVCaptureSession exportPresetForSessionPreset:self.sessionPreset];
}

+ (NSString*) exportPresetForSessionPreset:(NSString*)sessionPreset {
    if ([sessionPreset isEqualToString:AVCaptureSessionPresetHigh]) {
        return AVAssetExportPresetHighestQuality;
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPresetMedium]) {
        return AVAssetExportPresetMediumQuality;
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPresetLow]) {
        return AVAssetExportPresetLowQuality;
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        return AVAssetExportPreset1920x1080;
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        return AVAssetExportPreset1280x720;
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        return AVAssetExportPreset640x480;
    }
    NSLog(@"Cannot find equal export preset");
    return nil;
}

@end

