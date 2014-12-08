//
//  SBAssetStitcher.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAssetStitcher.h"
#import "AVCaptureSession+Extension.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SBAssetStitcher ()

@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) AVMutableCompositionTrack *compositionVideoTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *compositionAudioTrack;

@end

@implementation SBAssetStitcher

- (instancetype)init {
    if (self = [super init]) {
        self.orientation = AVCaptureVideoOrientationPortrait;
        [self reset];
    }
    return self;
}

- (void) reset {
    self.composition = [AVMutableComposition composition];
    self.compositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    self.compositionAudioTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
}

- (double) rotationForOrientation {
    switch (self.orientation) {
        case AVCaptureVideoOrientationPortrait:
            return M_PI_2;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return M_PI_2;
        case AVCaptureVideoOrientationLandscapeRight:
            return 0;
        default: //AVCaptureVideoOrientationLandscapeLeft
            return M_PI;
    }
}

- (CGAffineTransform) tranformForOrientation {
    return CGAffineTransformMakeRotation([self rotationForOrientation]);
}

- (RACSignal*)addAsset:(AVURLAsset *)asset {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        NSError *error;
        [self.compositionVideoTrack insertTimeRange:timeRange ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        if (error) {
            [subscriber sendError:error];
            return nil;
        }
        
        error = nil;
        [self.compositionAudioTrack insertTimeRange:timeRange ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        
        if(error) {
            [subscriber sendError:error];
            return nil;
        }
        
        [subscriber sendCompleted];

        return nil;
    }];
}

- (RACSignal*)exportTo:(NSURL *)outputFileURL preset:(NSString *)preset {
    return [self exportTo:outputFileURL preset:preset square:NO];
}

- (RACSignal*)exportTo:(NSURL *)outputFileURL preset:(NSString *)preset square:(BOOL)isSquare {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];

        self.compositionVideoTrack.preferredTransform = [self tranformForOrientation];
        
        NSArray *array = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.composition];
        
        AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.composition presetName:preset];
        exporter.outputURL = outputFileURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        exporter.canPerformMultiplePassesOverSourceMediaData = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            NSError *error = exporter.error;
            
            switch([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                    [subscriber sendError:error];
                    break;
                case AVAssetExportSessionStatusCancelled:
                    [subscriber sendError:[NSError errorWithDomain:@"Export cancelled" code:100 userInfo:nil]];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    if (isSquare) {
                        [[self reexportToSquareVideoFromURL:outputFileURL toURL:outputFileURL preset:preset] subscribe:subscriber];
                    } else {
                        [subscriber sendNext:outputFileURL];
                        [subscriber sendCompleted];
                    }
                    break;
                default:
                    [subscriber sendError:[NSError errorWithDomain:@"Unknown export error" code:100 userInfo:nil]];
                    break;
            }
        }];
        
        return nil;
    }];
}

- (RACSignal*)reexportToSquareVideoFromURL:(NSURL*)fromURL toURL:(NSURL*)toURL preset:(NSString*)preset {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:fromURL];
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        
        CGSize size = [AVCaptureSession renderSizeForExportPrest:preset];
        
        // make it square
        AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.renderSize = CGSizeMake(size.height, size.height);
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
                finalTransform = CGAffineTransformMakeTranslation(size.height, -(size.width - size.height) /2 );
                finalTransform = CGAffineTransformRotate(finalTransform, M_PI_2);
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

        [[NSFileManager defaultManager] removeItemAtURL:toURL error:nil];
        
        AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:asset presetName:preset];
        exporter.videoComposition = videoComposition;
        exporter.outputURL = toURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            NSError *error = exporter.error;
            switch([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                    [subscriber sendError:error];
                    break;
                case AVAssetExportSessionStatusCancelled:
                    [subscriber sendError:[NSError errorWithDomain:@"Export cancelled" code:100 userInfo:nil]];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    [subscriber sendNext:toURL];
                    [subscriber sendCompleted];
                    break;
                default:
                    [subscriber sendError:[NSError errorWithDomain:@"Unknown export error" code:100 userInfo:nil]];
                    break;
            }
        }];
        
        return nil;
    }];
}

@end
