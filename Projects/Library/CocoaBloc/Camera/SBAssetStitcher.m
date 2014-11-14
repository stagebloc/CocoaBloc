//
//  SBAssetStitcher.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//  Source code taken & modified from https://github.com/carsonmcdonald/iOSVideoCameraMultiStitchExample 11/14/2014 - MIT LICENSE
//

#import "SBAssetStitcher.h"



@interface SBAssetStitcher ()

@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) AVMutableCompositionTrack *compositionVideoTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *compositionAudioTrack;
@property (nonatomic, strong) NSMutableArray *instructions;

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
    self.instructions = [[NSMutableArray alloc] init];
}

- (void)addAsset:(AVURLAsset *)asset transformation:(CGAffineTransform (^)(AVAssetTrack *videoTrack))transformToApply error:(void (^)(NSError *error))errorHandler {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.compositionVideoTrack];
    
    // Apply a transformation to the video if one has been given. If a transformation is given it is combined
    // with the preferred transform contained in the incoming video track
    if(transformToApply) {
        [layerInstruction setTransform:CGAffineTransformConcat(videoTrack.preferredTransform, transformToApply(videoTrack))
                                atTime:kCMTimeZero];
    }
    else {
        [layerInstruction setTransform:videoTrack.preferredTransform
                                atTime:kCMTimeZero];
    }
    
    instruction.layerInstructions = @[layerInstruction];
    
    __block CMTime startTime = kCMTimeZero;
    [self.instructions enumerateObjectsUsingBlock:^(AVMutableVideoCompositionInstruction *previousInstruction, NSUInteger idx, BOOL *stop) {
        startTime = CMTimeAdd(startTime, previousInstruction.timeRange.duration);
    }];
    instruction.timeRange = CMTimeRangeMake(startTime, asset.duration);
    [self.instructions addObject:instruction];
    
    NSError *error;
    [self.compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
    
    if(error) {
        errorHandler(error);
        return;
    }
    
    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [self.compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
    
    if(error) {
        errorHandler(error);
    }
}

- (void)exportTo:(NSURL *)outputFile renderSize:(CGSize)renderSize preset:(NSString *)preset completion:(void (^)(NSError *error))completion {
    if (completion == nil) completion = ^(NSError*e){};
    
    renderSize = (self.orientation == AVCaptureVideoOrientationPortrait || self.orientation == AVCaptureVideoOrientationPortraitUpsideDown) ? CGSizeMake(renderSize.height, renderSize.width) : renderSize;
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = self.instructions;
    videoComposition.renderSize = renderSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:self.composition presetName:preset];
    NSParameterAssert(exporter != nil);
    
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.videoComposition = videoComposition;
    exporter.outputURL = outputFile;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                completion(exporter.error);
                break;
            case AVAssetExportSessionStatusCancelled:
            case AVAssetExportSessionStatusCompleted:
                completion(nil);
                break;
            default:
                completion([NSError errorWithDomain:@"Unknown export error" code:100 userInfo:nil]);
                break;
        }
        
    }];
}


@end
