//
//  SCVideoManager.m
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//  Source code taken & modified from https://github.com/carsonmcdonald/iOSVideoCameraMultiStitchExample 11/14/2014 - MIT LICENSE
//

#import "SBVideoManager.h"
#import "SBAssetStitcher.h"
#import "AVCaptureSession+Extension.h"
#import "UIDevice+Orientation.h"
#import "UIDevice+CocoaBloc.h"
#import "NSUserDefaults+Camera.h"
#import "SBComposition.h"
#import "NSURL+Camera.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

CGFloat aspectRatio(CGSize size) {
    return size.width / size.height;
}

@interface SBVideoManager () <AVCaptureFileOutputRecordingDelegate> {
    id deviceConnectedObserver;
    id deviceDisconnectedObserver;
    id deviceOrientationDidChangeObserver;
}

@property (nonatomic) AVCaptureDeviceInput *videoInput;
@property (nonatomic) AVCaptureDeviceInput *audioInput;

@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, assign) AVCaptureVideoOrientation currentOrientation;
@property (nonatomic, assign) AVCaptureVideoOrientation startOrientation;

@property (nonatomic, assign) NSInteger currentRecordingSegment;

@property (nonatomic, assign) CMTime currentFinalDuration;
@property (nonatomic, assign) NSInteger currentWrites;

@property (nonatomic) SBAssetStitcher *stitcher;

@property (nonatomic, assign) BOOL paused;

@property (nonatomic, copy) NSString *specificSessionPreset;

@end

@implementation SBVideoManager

@synthesize aspectRatio = _aspectRatio;

- (SBAssetStitcher*) stitcher {
    if (!_stitcher)
        _stitcher = [[SBAssetStitcher alloc] init];
    return _stitcher;
}

- (BOOL) isPaused {
    return self.paused;
}

- (void) setAspectRatio:(SBCameraAspectRatio)aspectRatio {
    [self willChangeValueForKey:@"aspectRatio"];
    _aspectRatio = aspectRatio;
    [self didChangeValueForKey:@"aspectRatio"];
    [NSUserDefaults setAspectRatio:aspectRatio];
}

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super initWithCaptureSession:session]) {
        self.squareVideoOffsetBottom = 20;
        
        _currentRecordingSegment = 0;
        self.paused = NO;
        _maxDuration = 0;
        _currentWrites = 0;
        
        self.aspectRatio = [NSUserDefaults aspectRatio];
        
        self.currentFinalDuration = kCMTimeZero;

        self.devicePosition = AVCaptureDevicePositionBack;
        
        self.maxDuration = 10.0f;
        self.minDuration = 0.0f;
                
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        [self reset];
        [self startNotificationObservers];
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        self.specificSessionPreset = [self.captureSession bestSessionPreset];

        self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
        if([self.captureSession canAddInput:self.audioInput]) {
            [self.captureSession addInput:self.audioInput];
        } else {
            NSLog(@"Error setting audio input");
        }
        
        if([self.captureSession canAddOutput:self.movieFileOutput]) {
            [self.captureSession addOutput:self.movieFileOutput];
        } else {
            NSLog(@"Error setting file output");
        }
    }
    return self;
}

- (void)dealloc {
    [self.captureSession removeOutput:self.movieFileOutput];
    [self endNotificationObservers];
}

- (void) updateVideoConnectionWithOrientation:(AVCaptureVideoOrientation)orientation {
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:self.movieFileOutput.connections];
    if ([videoConnection isVideoOrientationSupported]) {
        videoConnection.videoOrientation = orientation;
    }
    if (videoConnection.supportsVideoStabilization) {
        videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
}

//only updates specificSessionPreset to the lowest
//quality used preset
- (void) updateSpecificPreset {
    CGSize currentRenderSize = [AVCaptureSession renderSizeForSessionPreset:self.specificSessionPreset];
    
    NSString *newSpecificPreset = [self.captureSession bestSessionPreset];
    CGSize newRenderSize = [AVCaptureSession renderSizeForSessionPreset:newSpecificPreset];
    if (newRenderSize.width < currentRenderSize.width || newRenderSize.height < currentRenderSize.height) {
        self.specificSessionPreset = newSpecificPreset;
    }
}

- (void)startRecording {
    [self.stitcher reset];

    self.currentRecordingSegment = 0;
    self.paused = NO;
    self.currentFinalDuration = kCMTimeZero;
    
    self.startOrientation = self.currentOrientation;
    [self updateVideoConnectionWithOrientation:self.currentOrientation];
    
    self.specificSessionPreset = [self.captureSession bestSessionPreset];
    
    NSURL *outputFileURL = [NSURL randomTemporaryMP4FileURLWithPrefix:@"recordingsegment"];
    self.movieFileOutput.maxRecordedDuration = (_maxDuration > 0) ? CMTimeMakeWithSeconds(_maxDuration, 600) : kCMTimeInvalid;
    [self.movieFileOutput startRecordingToOutputFileURL:outputFileURL recordingDelegate:self];
}

- (void)pauseRecording {
    if (self.isPaused)
        return;
    
    self.paused = YES;
    [self.movieFileOutput stopRecording];
    self.currentFinalDuration = CMTimeAdd(self.currentFinalDuration, self.movieFileOutput.recordedDuration);
    [self updateVideoConnectionWithOrientation:self.currentOrientation];
}

- (BOOL) resumeRecording {
    if (CMTimeGetSeconds([self totalRecordingDuration]) >= self.maxDuration)
        return NO;
    
    [self updateSpecificPreset];
    
    [self updateVideoConnectionWithOrientation:self.currentOrientation];
    
    self.currentRecordingSegment++;
    
    if(_maxDuration > 0) {
        self.movieFileOutput.maxRecordedDuration = CMTimeSubtract(CMTimeMakeWithSeconds(_maxDuration, 600), self.currentFinalDuration);
    } else {
        self.movieFileOutput.maxRecordedDuration = kCMTimeInvalid;
    }
    
    NSURL *outputFileURL = [NSURL randomTemporaryMP4FileURLWithPrefix:@"recordingsegment"];
    [self.movieFileOutput startRecordingToOutputFileURL:outputFileURL recordingDelegate:self];
    self.paused = NO;

    return YES;
}

- (void)reset {
    if (self.movieFileOutput.isRecording) {
        [self pauseRecording];
    }
    
    [self.stitcher reset];
    self.currentFinalDuration = kCMTimeZero;
    
    self.paused = NO;
    
    [self updateVideoConnectionWithOrientation:self.currentOrientation];
}

- (CMTime)totalRecordingDuration {
    if (self.currentWrites <= 0) {
        return self.currentFinalDuration;
    }
    
    if(CMTimeCompare(kCMTimeZero, self.currentFinalDuration) == 0 && ![self isReset]) {
        return self.movieFileOutput.recordedDuration;
    } else if (!self.paused && self.movieFileOutput.isRecording) {
        CMTime returnTime = CMTimeAdd(self.currentFinalDuration, self.movieFileOutput.recordedDuration);
        return CMTIME_IS_INVALID(returnTime) ? self.currentFinalDuration : returnTime;
    } else {
        return self.currentFinalDuration;
    }
}

- (BOOL) isPastMinDuration {
    if (CMTimeGetSeconds([self totalRecordingDuration]) > self.minDuration) {
        return YES;
    }
    return NO;
}

- (BOOL) isReset {
    return !self.movieFileOutput.isRecording && !self.isPaused;
}

- (BOOL) isRecording {
    return self.movieFileOutput.isRecording;
}

#pragma mark - Signals
- (RACSignal*)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL {
    return [self finalizeRecordingToFile:finalVideoLocationURL takeUntil:nil];
}

- (RACSignal*)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL takeUntil:(RACSignal*)takeUntil {
    @weakify(self);
    
    //pause just in case
    if (self.isRecording) {
        [self pauseRecording];
    }
    
    if([finalVideoLocationURL checkResourceIsReachableAndReturnError:nil]) {
        return [RACSignal error:[NSError errorWithDomain:@"Output file already exists." code:104 userInfo:nil]];
    }
    
    if(self.currentWrites != 0) {
        return [RACSignal error:[NSError errorWithDomain:@"Can't finalize recording unless all sub-recorings are finished." code:106 userInfo:nil]];
    }


    SBAssetStitcherOptions *options = [SBAssetStitcherOptions optionsWithOrientation:self.startOrientation
                                                                        exportPreset:[AVCaptureSession exportPresetForSessionPreset:self.specificSessionPreset]];
    BOOL isSquare = self.aspectRatio == SBCameraAspectRatioSquare;
    
    //Individual Composition construction handling
    CGSize lowestRenderSize = [AVCaptureSession renderSizeForSessionPreset:self.specificSessionPreset];
    CGFloat lowestAspectRatio = aspectRatio(lowestRenderSize);
    CGSize (^individualRenderSizeHandler)(SBComposition *comp) = ^(SBComposition *comp) {
        CGFloat compAspectRatio = aspectRatio(comp.naturalSize);
        //ignore aspect ratio modification if lowestAspectRatio is > compAspectRatio
        if (lowestAspectRatio >= compAspectRatio)
            return comp.naturalSize;
        
        //aspect ratio not equal, must make same aspect ratio
        CGFloat min = MIN(comp.naturalSize.width, comp.naturalSize.height);
        CGFloat max = MAX(comp.naturalSize.width, comp.naturalSize.height);
        
        if (max == comp.naturalSize.width) {
            return CGSizeMake(max / lowestAspectRatio, min);
        } else {
            return CGSizeMake(min, max / lowestAspectRatio);
        }
    };
    [options setIndividualCompositionHandler:^(SBComposition *comp) {
        comp.renderSize = individualRenderSizeHandler(comp);
        
        if (isSquare) {
            @strongify(self);
            CGFloat ptsToPixels = comp.renderSize.width / self.squareVideoSize;
            CGFloat offsetInPixels = self.squareVideoOffsetBottom * ptsToPixels;
            comp.offsetBottom = offsetInPixels;
        }
    }];
    
    //Final Composition construction handling
    CGSize (^finalRenderSizeHandler)(SBComposition *comp) = ^(SBComposition *comp) {
        if (isSquare) {
            CGFloat min = MIN(comp.naturalSize.width, comp.naturalSize.height);
            return CGSizeMake(min, min);
        }
        return comp.naturalSize;
    };
    [options setFinalCompositionHandler:^(SBComposition *comp) {
        comp.renderSize = finalRenderSizeHandler(comp);
    }];
    
    RACSignal *exportSignal = [self.stitcher exportTo:finalVideoLocationURL options:options];
    if (takeUntil) exportSignal = [exportSignal takeUntil:takeUntil];

    return exportSignal;
}

- (RACSignal*)totalTimeRecordedSignal {
    return RACObserve(self, currentFinalDuration);
}

- (RACSignal*) recordDurationChangeSignal {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[RACSignal interval:0.01f onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]] subscribeNext:^(id x) {
            @strongify(self);
            [subscriber sendNext:[NSValue valueWithCMTime:[self totalRecordingDuration]]];
        }];
        return nil;
    }];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate implementation
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    self.currentWrites++;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    //pause just in case
    if (!self.isPaused) {
        [self pauseRecording];
    }
    
    if(!fileURL){
        NSLog(@"Error capturing output: %@", error);
    } else {
        [self.stitcher addAsset:[[AVURLAsset alloc] initWithURL:fileURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES}] devicePosition:self.devicePosition];
    }
    
    self.currentWrites--;
}

#pragma mark - Observer start and stop
- (void)startNotificationObservers {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //Reconnect to a device that was previously being used
    deviceConnectedObserver = [notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        AVCaptureDevice *device = [notification object];
        NSString *deviceMediaType = nil;
        if ([device hasMediaType:AVMediaTypeAudio]) {
            deviceMediaType = AVMediaTypeAudio;
        } else if ([device hasMediaType:AVMediaTypeVideo]) {
            deviceMediaType = AVMediaTypeVideo;
        }
        
        if (deviceMediaType != nil) {
            [self.captureSession.inputs enumerateObjectsUsingBlock:^(AVCaptureDeviceInput *input, NSUInteger idx, BOOL *stop) {
                if ([input.device hasMediaType:deviceMediaType]) {
                    NSError	*error;
                    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                    if ([self.captureSession canAddInput:deviceInput]) {
                        [self.captureSession addInput:deviceInput];
                    }
                    if(error) {
                        NSLog(@"Error reconnecting device input: %@", error);
                    }
                    *stop = YES;
                }
                
            }];
        }
    }];
    
    //Disable inputs from removed devices that are being used
    deviceDisconnectedObserver = [notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        AVCaptureDevice *device = [notification object];
        if ([device hasMediaType:AVMediaTypeAudio]) {
            [self.captureSession removeInput:self.audioInput];
            self.audioInput = nil;
        }
        else if ([device hasMediaType:AVMediaTypeVideo]) {
            [self.captureSession removeInput:self.videoInput];
            self.videoInput = nil;
        }
    }];
    
    //Track orientation changes
    self.currentOrientation = (NSInteger)[[UIDevice currentDevice] videoOrientation] == -1 ? AVCaptureVideoOrientationPortrait : [[UIDevice currentDevice] videoOrientation];
    deviceOrientationDidChangeObserver = [notificationCenter addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        AVCaptureVideoOrientation orientation = [[UIDevice currentDevice] videoOrientation];
        if ((NSInteger)orientation != -1) {
            self.currentOrientation = orientation;
            if (!self.isRecording)
                [self updateVideoConnectionWithOrientation:orientation];
        }
    }];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)endNotificationObservers {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:deviceConnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:deviceDisconnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:deviceOrientationDidChangeObserver];
}

#pragma mark - Device finding methods
- (AVCaptureDevice *)audioDevice {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if (devices.count > 0) {
        return devices[0];
    }
    return nil;
}

#pragma mark - Connection finding method
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    __block AVCaptureConnection *foundConnection = nil;
    [connections enumerateObjectsUsingBlock:^(AVCaptureConnection *connection, NSUInteger idx, BOOL *connectionStop) {
        [connection.inputPorts enumerateObjectsUsingBlock:^(AVCaptureInputPort *port, NSUInteger idx, BOOL *portStop) {
            if( [port.mediaType isEqual:mediaType] ) {
                foundConnection = connection;
                *connectionStop = YES;
                *portStop = YES;
            }
        }];
    }];
    return foundConnection;
}

@end
