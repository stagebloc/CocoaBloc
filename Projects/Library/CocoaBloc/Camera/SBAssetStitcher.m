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
            return CGAffineTransformMakeRotation(M_PI);
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(M_PI*2);
        default: //AVCaptureVideoOrientationLandscapeLeft
            return CGAffineTransformMakeRotation(0);
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
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        self.compositionVideoTrack.preferredTransform = [self tranformForOrientation];
        
        AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.composition presetName:preset];
        exporter.outputURL = outputFileURL;
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
