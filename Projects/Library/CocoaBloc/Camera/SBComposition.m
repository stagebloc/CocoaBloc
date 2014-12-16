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
        _renderSize = CGSizeZero;
    }
    return self;
}

- (double) rotationForOrientation:(AVCaptureVideoOrientation)orientation devicePosition:(AVCaptureDevicePosition)devicePosition {
    BOOL isFront = devicePosition == AVCaptureDevicePositionFront;
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            return M_PI_2;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return -M_PI_2;
        case AVCaptureVideoOrientationLandscapeRight:
            return isFront ? M_PI : 0;
        default: //AVCaptureVideoOrientationLandscapeLeft
            return isFront ? 0 : M_PI;
    }
}

- (CGAffineTransform) tranformForOrientation:(AVCaptureVideoOrientation)orientation devicePosition:(AVCaptureDevicePosition)devicePosition {
    return CGAffineTransformMakeRotation([self rotationForOrientation:orientation devicePosition:devicePosition]);
}

#pragma mark - Signals
- (RACSignal*) fetchAsset {
    AVAssetTrack *videoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize size = self.renderSize;
    
    // make it square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = size;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = videoTrack.timeRange;
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    CGAffineTransform finalTransform;
    
    switch (self.orientation) {
        case AVCaptureVideoOrientationPortrait:
            finalTransform = CGAffineTransformMakeTranslation(size.height, -(size.width - size.height) /2 );
            finalTransform = CGAffineTransformRotate(finalTransform, M_PI_2);
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            finalTransform = CGAffineTransformMakeTranslation(0, (size.width - size.height) * (size.width / size.height));
            finalTransform = CGAffineTransformRotate(finalTransform, -M_PI_2);
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            finalTransform = CGAffineTransformMakeTranslation(-(size.width - size.height), 0);
            finalTransform = CGAffineTransformRotate(finalTransform, 0);
            break;
        default: //AVCaptureVideoOrientationLandscapeLeft
            finalTransform = CGAffineTransformMakeTranslation((size.width - size.height) * (size.width / size.height) , size.height);
            finalTransform = CGAffineTransformRotate(finalTransform, M_PI);
            break;
    }
    
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    [[NSFileManager defaultManager] removeItemAtURL:self.outputURL error:nil];
    
    AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.asset presetName:self.exportPreset outputURL:self.outputURL];
//    exporter.videoComposition = videoComposition;
    
    return [[exporter exportAsynchronously] map:^AVAsset*(NSURL *savedToURL) {
        return [[AVURLAsset alloc] initWithURL:savedToURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES}];
    }];
}

@end
