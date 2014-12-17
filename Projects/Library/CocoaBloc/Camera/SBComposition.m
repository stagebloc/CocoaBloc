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

- (instancetype) initWithAsset:(AVAsset *)asset {
    if (self = [super init]) {
        _asset = asset;
        if ([asset respondsToSelector:@selector(URL)])
            _outputURL = ((AVURLAsset*)asset).URL;
        _orientation = AVCaptureVideoOrientationPortrait;
        _devicePosition = AVCaptureDevicePositionBack;
        
        AVAssetTrack *videoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        _renderSize = videoTrack.naturalSize;
        _naturalSize = videoTrack.naturalSize;
    }
    return self;
}

- (AVCaptureVideoOrientation) invertOrienation:(AVCaptureVideoOrientation)orientation {
    NSInteger orien = (NSInteger)orientation;
    if (orien % 2 == 0) orien--; else orien++;
    return (AVCaptureVideoOrientation)orien;
}

- (CGAffineTransform) transformTranslationFromNaturalSize:(CGSize)naturalSize
                                             toRenderSize:(CGSize)toRenderSize
                                              orientation:(AVCaptureVideoOrientation)orientation {
    CGFloat offset = self.offsetBottom; //* (self.devicePosition == AVCaptureDevicePositionFront ? -1 : 1);
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            return CGAffineTransformMakeTranslation(toRenderSize.width, -(naturalSize.height-toRenderSize.height)/2 + offset);
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return CGAffineTransformMakeTranslation(0, toRenderSize.height - offset);
        case AVCaptureVideoOrientationLandscapeRight:
            return CGAffineTransformMakeTranslation(0 + offset, 0);
        default: //AVCaptureVideoOrientationLandscapeLeft
            return CGAffineTransformMakeTranslation(toRenderSize.width - offset, toRenderSize.height);
    }
}

- (double) rotationFromOrientation:(AVCaptureVideoOrientation)orientation {
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            return M_PI_2;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return -M_PI_2;
        case AVCaptureVideoOrientationLandscapeRight:
            return 0;
        default: //AVCaptureVideoOrientationLandscapeLeft
            return M_PI;
    }
}

- (CGAffineTransform) transformFromNaturalSize:(CGSize)naturalSize toRenderSize:(CGSize)toRenderSize {
    //front cam is the opposite transforms of back camera
    //so we trick the switch statement in doing the opposite
    //transform by inverting the orientation
    //i.e. AVCaptureVideoOrientationLandscapeLeft = AVCaptureVideoOrientationLandscapeRight
    //when the camera is front facing
    AVCaptureVideoOrientation orientation = self.orientation;
    if (self.devicePosition == AVCaptureDevicePositionFront && (orientation == AVCaptureVideoOrientationLandscapeLeft || orientation == AVCaptureVideoOrientationLandscapeRight))
        orientation = [self invertOrienation:orientation];
    
    CGAffineTransform trans = [self transformTranslationFromNaturalSize:naturalSize toRenderSize:toRenderSize orientation:orientation];
    trans = CGAffineTransformRotate(trans, [self rotationFromOrientation:orientation]);
    return trans;
}

- (AVAssetExportSession*) exporter {
    CGSize orientatedRenderSize = [AVCaptureSession size:self.renderSize fromOrientation:self.orientation];
    CGSize orientatedNaturalSize = [AVCaptureSession size:self.naturalSize fromOrientation:self.orientation];
    return [self exporterWithTransform:[self transformFromNaturalSize:orientatedNaturalSize toRenderSize:orientatedRenderSize]];
}

- (AVAssetExportSession*) exporterWithTransform:(CGAffineTransform)transform {
    AVAssetTrack *videoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize size = [AVCaptureSession size:self.renderSize fromOrientation:self.orientation];
    
    // make it square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = size;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = videoTrack.timeRange;
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [transformer setTransform:transform atTime:kCMTimeZero];
    instruction.layerInstructions = @[transformer];
    videoComposition.instructions = @[instruction];
    
    AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.asset presetName:self.exportPreset outputURL:self.outputURL];
    exporter.videoComposition = videoComposition;
    return exporter;
}

#pragma mark - Signals
- (RACSignal*) createAsset {
    AVAssetExportSession *exporter = [self exporter];
    return [[exporter exportAsynchronously] map:^AVAsset*(NSURL *savedToURL) {
        return [[AVURLAsset alloc] initWithURL:savedToURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES}];
    }];
}

@end
