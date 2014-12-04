//
//  SBAssetStitcher.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAssetStitcher.h"

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

- (CGAffineTransform) tranformForOrientation {
    switch (self.orientation) {
        case AVCaptureVideoOrientationPortrait:
            return CGAffineTransformMakeRotation(M_PI_2);
        case AVCaptureVideoOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(0);
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(M_PI_2);
        default: //AVCaptureVideoOrientationLandscapeLeft
            return CGAffineTransformMakeRotation(M_PI);
    }
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
        
        self.compositionVideoTrack.preferredTransform = [self tranformForOrientation];
        
        AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.composition presetName:preset];
        exporter.outputURL = outputFileURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;

        if (isSquare) {
            // make it square
            AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
            videoComposition.renderSize = CGSizeMake(self.compositionVideoTrack.naturalSize.height, self.compositionVideoTrack.naturalSize.height);
            videoComposition.frameDuration = CMTimeMake(1, 30);
            
            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
            
            // rotate to portrait
            AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.compositionVideoTrack];
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(self.compositionVideoTrack.naturalSize.height, -(self.compositionVideoTrack.naturalSize.width - self.compositionVideoTrack.naturalSize.height) /2 );
            CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
            
            CGAffineTransform finalTransform = t2;
            [transformer setTransform:finalTransform atTime:kCMTimeZero];
            instruction.layerInstructions = [NSArray arrayWithObject:transformer];
            videoComposition.instructions = [NSArray arrayWithObject: instruction];
            
            exporter.videoComposition = videoComposition;
        }
        
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
                    [subscriber sendNext:outputFileURL];
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
