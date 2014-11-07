//
//  SCVideoManager.m
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCVideoManager.h"

BOOL CGAffineTransformIsPortrait(CGAffineTransform transtorm) {
    return (transtorm.a == 0 && transtorm.d == 0 && (transtorm.b == 1 || transtorm.b == -1) && (transtorm.c == 1 || transtorm.c == -1));
}

@interface SCVideoManager () <AVCaptureFileOutputRecordingDelegate>
/**
 * The movie files that combined will create a stitched video
 */
@property (nonatomic, strong) NSMutableArray *stitches;
@property (nonatomic, readonly) NSArray *compositions;
@end

@implementation SCVideoManager

- (id)initWithCaptureSession:(AVCaptureSession *)session
{
    self = [super initWithCaptureSession:session];
    if (self) {
        self.stitches = [NSMutableArray arrayWithCapacity:0];
        self.resetsOnOverflow = YES;
        self.maxVideoDuration = CMTimeMakeWithSeconds(10, 600);
    }
    return self;
}

- (AVCaptureDevice *)microphone
{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode
{
    NSError *error = nil;
    [self.currentCamera lockForConfiguration:&error];
    if (error) {
        // Appropriately handle error here
    } else {
        if ([self isTorchModeSupported:torchMode]) {
            self.currentCamera.torchMode = torchMode;
        }
        [self.currentCamera unlockForConfiguration];
    }
}

- (BOOL)isTorchAvailable
{
    return self.currentCamera.isTorchAvailable;
}

- (BOOL)isTorchActive
{
    return self.currentCamera.isTorchActive;
}

- (BOOL)isTorchModeSupported:(AVCaptureTorchMode)torchMode
{
    return [self.currentCamera isTorchModeSupported:torchMode];
}

- (void)resetRecordings
{
    for (NSURL *outputFileURL in self.stitches) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error = nil;
        [fm removeItemAtURL:outputFileURL error:&error];
        if (error) {
            // Handle error here
        }
    }
    [self.stitches removeAllObjects];
}

- (NSUInteger)currentStitchCount
{
    return self.stitches.count;
}

- (void)setFPS:(CMTime)FPS
{
    [self willChangeValueForKey:@"FPS"];
    _FPS = FPS;
    [self didChangeValueForKey:@"FPS"];
    NSError *error = nil;
    [self.currentCamera lockForConfiguration:&error];
    if (error) {
        // Handle error here
    } else {
        self.rearCamera.activeVideoMinFrameDuration = _FPS;
        self.frontFacingCamera.activeVideoMinFrameDuration = _FPS;
        [self.currentCamera unlockForConfiguration];
    }
}

#pragma mark - Override
- (void)setCameraType:(SCCameraType)cameraType
{
    [super setCameraType:cameraType];

    NSError *error = nil;
    [self.captureSession beginConfiguration];
    if (!self.micInput || ![self.captureSession.inputs containsObject:self.micInput]) {
        self.micInput = [AVCaptureDeviceInput deviceInputWithDevice:self.microphone error:&error];
        if ([self.captureSession canAddInput:self.micInput]) {
            [self.captureSession addInput:self.micInput];
        }
    }
    if (!self.output || ![self.captureSession.outputs containsObject:self.output]) {
        self.output = [AVCaptureMovieFileOutput new];
        if ([self.captureSession canAddOutput:self.output]) {
            [self.captureSession addOutput:self.output];
        }
    }
    [self.captureSession commitConfiguration];
}

// Returns no if we've already returned the maximum amount of stitches
- (BOOL)startCapture
{
    if (self.maximumStitchCount > 0 && self.currentStitchCount == self.maximumStitchCount) { // if we've reached our max stitch count
        if (self.resetsOnOverflow) { // if we reset on overflow
            [self resetRecordings]; // reset our recordings
            return [self startCapture]; // and start our capture again
        }
        return NO; // else we just want to return a failed capture
    }
    // enable URL
    self.output.maxRecordedDuration = self.maxVideoDuration;
    AVCaptureConnection *connection = [self.output connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    NSString *URLString = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mov", (NSInteger)[[NSDate date] timeIntervalSince1970]]];
    NSURL *outputURL = [NSURL fileURLWithPath:URLString];
    [self.output startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    return YES;
}

// Returns an NSURL iff we've hit the max stitch limit, or max duration
- (void)stopCapture {
    if (self.captureSession.outputs.count > 0) {
        [self.output stopRecording];
    }
}

- (NSURL *)outputURL
{
    // return a stitched video from the temp cache
    NSArray *comps = self.compositions;
    return self.stitches.count > 0 ? [self exportVideoFromComposition:comps[0] withVideoComposition:comps[1] completion:nil] : nil;
}

- (BOOL) saveVideoLocally:(void (^)(NSURL *assetURL, NSError *error))completion {
    if (self.stitches.count == 0)
        return NO;
    NSArray *comps = self.compositions;
    [self exportVideoFromComposition:comps[0] withVideoComposition:comps[1] completion:completion];
    return YES;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    [self.stitches addObject:captureOutput.outputFileURL];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error) {
        [self.stitches removeObject:captureOutput.outputFileURL];
    } else {
        [self.captureSession beginConfiguration];
        [self.captureSession removeOutput:self.stitches.lastObject];
        [self.captureSession commitConfiguration];
    }
    
    if (self.captureOutputFinishedProcessing)
        self.captureOutputFinishedProcessing(captureOutput, outputFileURL, connections, error);
}

#pragma mark - Helpers

- (NSArray *)compositions
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    for (NSURL *URL in self.stitches) {
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @YES}];
        AVAssetTrack *videoTrack = [asset compatibleTrackForCompositionTrack:videoCompositionTrack];
        NSError *videoError = nil;
        [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration) ofTrack:videoTrack atTime:videoCompositionTrack.timeRange.duration error:&videoError];
        if (videoError) {
            // Handle error here
            NSLog(@"currentComposition :: videoError :: %@", videoError);
        } else {
            if (!CGAffineTransformIsPortrait(asset.preferredTransform)) {
                AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
                AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
                CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.f), M_PI_2);
                [layerInstruction setTransform:transform atTime:kCMTimeZero];
                instruction.timeRange = CMTimeRangeMake(CMTimeSubtract(videoCompositionTrack.timeRange.duration, videoTrack.timeRange.duration), videoTrack.timeRange.duration);
                instruction.layerInstructions = instruction.layerInstructions.count == 0 ? @[layerInstruction] : [instruction.layerInstructions arrayByAddingObject:layerInstruction];
                videoComposition.renderSize = CGSizeMake(fabsf(videoTrack.naturalSize.height), fabsf(videoTrack.naturalSize.width));
                videoComposition.frameDuration = CMTimeMake(1, 30);
                videoComposition.instructions = videoComposition.instructions.count > 0 ? [videoComposition.instructions arrayByAddingObject:instruction] : @[instruction];
            }
        }
        AVAssetTrack *audioTrack = [asset compatibleTrackForCompositionTrack:audioCompositionTrack];
        NSError *audioError = nil;
        [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioTrack.timeRange.duration) ofTrack:audioTrack atTime:audioCompositionTrack.timeRange.duration error:&audioError];
        if (audioError) {
            // Handle error here
            NSLog(@"currentComposition :: audioError :: %@", audioError);
        }
    }
    return @[composition, videoComposition];
}

- (NSURL *)exportVideoFromComposition:(AVComposition *)composition withVideoComposition:(AVVideoComposition *)videoComposition completion:(void (^)(NSURL *assetURL, NSError *error))completion
{
    NSString *URLString = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mov", (NSInteger)[[NSDate date] timeIntervalSince1970]]];
    NSURL *outputURL = [NSURL fileURLWithPath:URLString];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = outputURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComposition;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.status == AVAssetExportSessionStatusCompleted) {
            ALAssetsLibrary *library = [ALAssetsLibrary new];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exporter.outputURL]) {
                [library writeVideoAtPathToSavedPhotosAlbum:exporter.outputURL completionBlock:^(NSURL *assetURL, NSError *error) {
                    if (error) {
                        NSLog(@"exportVideoFromComposition :: error :: %@", error);
                    } else {
                        NSLog(@"Wrote to library successfully");
                    }
                    
                    if (completion)
                        completion(assetURL, error);
                }];
            } else {
                if (completion)
                    completion(nil, [NSError errorWithDomain:@"exportVideo" code:500 userInfo:@{@"error":@"Incompatible video"}]);

                NSLog(@"Incompatible video");
            }
        } else {
            // Handle other statuses here
            NSLog(@"exportVideoFromComposition :: otherStatus :: %ld :: %@", (long)exporter.status, exporter.error);
        }
    }];
    return outputURL;
}

-(void)exportMedia
{

}



@end
