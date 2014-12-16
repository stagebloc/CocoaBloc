//
//  SBComposition.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBComposition.h"
#import "AVAssetExportSession+Extension.h"
#import "AVCaptureSession+Extension.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SBComposition ()

@end

@implementation SBComposition

- (instancetype) initWithAsset:(AVURLAsset *)asset {
    if (self = [super init]) {
        _asset = asset;
        _outputURL = asset.URL;
        _orientation = AVCaptureVideoOrientationPortrait;
        _devicePosition = AVCaptureDevicePositionBack;
        
        AVAssetTrack *videoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        _renderSize = videoTrack.naturalSize;
    }
    return self;
}

- (CGSize) renderSizeFromOrientation:(AVCaptureVideoOrientation)orientation {
    if(orientation == AVCaptureVideoOrientationPortrait || orientation == AVCaptureVideoOrientationPortraitUpsideDown)
        return CGSizeMake(self.renderSize.height, self.renderSize.width);
    return self.renderSize;
}

- (AVCaptureVideoOrientation) invertOrienation:(AVCaptureVideoOrientation)orientation {
    NSInteger orien = (NSInteger)orientation;
    if (orien % 2 == 0) orien--; else orien++;
    return (AVCaptureVideoOrientation)orien;
}

- (CGAffineTransform) transformWithSize:(CGSize)size {
    CGAffineTransform finalTransform;
    AVCaptureVideoOrientation orientation = self.orientation;

    //front cam is the opposite transforms of back camera
    //so we trick the switch statement in doing the opposite
    //transform by inverting the orientation
    //i.e. AVCaptureVideoOrientationLandscapeLeft = AVCaptureVideoOrientationLandscapeRight
    //when the camera is front facing
    if (self.devicePosition == AVCaptureDevicePositionFront && (orientation == AVCaptureVideoOrientationLandscapeLeft || orientation == AVCaptureVideoOrientationLandscapeRight))
        orientation = [self invertOrienation:orientation];
    
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            finalTransform = CGAffineTransformMakeTranslation(size.width, 0);
            finalTransform = CGAffineTransformRotate(finalTransform, M_PI_2);
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            finalTransform = CGAffineTransformMakeTranslation(0, size.height);
            finalTransform = CGAffineTransformRotate(finalTransform, -M_PI_2);
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            finalTransform = CGAffineTransformMakeTranslation(0, 0);
            finalTransform = CGAffineTransformRotate(finalTransform, 0);
            break;
        default: //AVCaptureVideoOrientationLandscapeLeft
            finalTransform = CGAffineTransformMakeTranslation(size.width, size.height);
            finalTransform = CGAffineTransformRotate(finalTransform, M_PI);
            break;
    }
    return finalTransform;
}

#pragma mark - Signals
- (RACSignal*) fetchAsset {
    AVAssetTrack *videoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize size = [self renderSizeFromOrientation:self.orientation];
    
    // make it square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = size;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = videoTrack.timeRange;
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [transformer setTransform:[self transformWithSize:size] atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    [[NSFileManager defaultManager] removeItemAtURL:self.outputURL error:nil];
    
    AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.asset presetName:self.exportPreset outputURL:self.outputURL];
    exporter.videoComposition = videoComposition;
    
    return [[exporter exportAsynchronously] map:^AVAsset*(NSURL *savedToURL) {
        return [[AVURLAsset alloc] initWithURL:savedToURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES}];
    }];
}

@end
