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

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SBVideoManager () <AVCaptureFileOutputRecordingDelegate> {
    id deviceConnectedObserver;
    id deviceDisconnectedObserver;
    id deviceOrientationDidChangeObserver;
}

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureVideoOrientation orientation;

@property (nonatomic, strong) NSMutableArray *temporaryFileURLs;

@property (nonatomic, assign) NSTimeInterval uniqueTimestamp;
@property (nonatomic, assign) NSInteger currentRecordingSegment;

@property (nonatomic, assign) CMTime currentFinalDurration;
@property (nonatomic, assign) NSInteger currentWrites;

@property (nonatomic, strong) SBAssetStitcher *stitcher;

@property (nonatomic, assign) BOOL paused;

@end

@implementation SBVideoManager

- (SBAssetStitcher*) stitcher {
    if (!_stitcher)
        _stitcher = [[SBAssetStitcher alloc] init];
    return _stitcher;
}

- (BOOL) isPaused {
    return self.paused;
}

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super initWithCaptureSession:session]) {
        _temporaryFileURLs = [[NSMutableArray alloc] init];
        _currentRecordingSegment = 0;
        self.paused = NO;
        _maxDuration = 0;
        _currentWrites = 0;
        
        self.currentFinalDurration = kCMTimeZero;

        self.devicePosition = AVCaptureDevicePositionBack;
        
        self.maxDuration = 10.0f;
        self.minDuration = 3.0f;
                
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        [self reset];
        [self startNotificationObservers];
        
        self.captureSession.sessionPreset = [self.captureSession bestSessionPreset];
        
        
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

- (void)startRecording {
    [self.temporaryFileURLs removeAllObjects];
    
    self.uniqueTimestamp = [[NSDate date] timeIntervalSince1970];
    self.currentRecordingSegment = 0;
    self.paused = NO;
    self.currentFinalDurration = kCMTimeZero;
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:self.movieFileOutput.connections];
    if ([videoConnection isVideoOrientationSupported]) {
        videoConnection.videoOrientation = self.orientation;
    }
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:[self constructCurrentTemporaryFilename]];
    [self.temporaryFileURLs addObject:outputFileURL];
    
    self.movieFileOutput.maxRecordedDuration = (_maxDuration > 0) ? CMTimeMakeWithSeconds(_maxDuration, 600) : kCMTimeInvalid;
    [self.movieFileOutput startRecordingToOutputFileURL:outputFileURL recordingDelegate:self];
}

- (void)pauseRecording {
    if (self.isPaused)
        return;
    
    self.paused = YES;
    [self.movieFileOutput stopRecording];
    self.currentFinalDurration = CMTimeAdd(self.currentFinalDurration, self.movieFileOutput.recordedDuration);
}

- (BOOL) resumeRecording {
    if (CMTimeGetSeconds([self totalRecordingDuration]) >= self.maxDuration)
        return NO;
    
    self.currentRecordingSegment++;
    self.paused = NO;
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:[self constructCurrentTemporaryFilename]];
    [self.temporaryFileURLs addObject:outputFileURL];
    
    if(_maxDuration > 0) {
        self.movieFileOutput.maxRecordedDuration = CMTimeSubtract(CMTimeMakeWithSeconds(_maxDuration, 600), self.currentFinalDurration);
    } else {
        self.movieFileOutput.maxRecordedDuration = kCMTimeInvalid;
    }
    
    [self.movieFileOutput startRecordingToOutputFileURL:outputFileURL recordingDelegate:self];
    return YES;
}

- (void)reset {
    if (self.movieFileOutput.isRecording) {
        [self pauseRecording];
    }
    
    [self cleanTemporaryFiles];
    [self.temporaryFileURLs removeAllObjects];
    self.currentFinalDurration = kCMTimeZero;
    
    self.paused = NO;
}

- (CMTime)totalRecordingDuration {
    if(CMTimeCompare(kCMTimeZero, self.currentFinalDurration) == 0 && ![self isReset]) {
        return self.movieFileOutput.recordedDuration;
    } else if ((!self.paused && self.movieFileOutput.isRecording)) {
        CMTime returnTime = CMTimeAdd(self.currentFinalDurration, self.movieFileOutput.recordedDuration);
        return CMTIME_IS_INVALID(returnTime) ? self.currentFinalDurration : returnTime;
    } else {
        return self.currentFinalDurration;
    }
}

- (BOOL) isPastMinDuration {
    if (CMTimeGetSeconds([self totalRecordingDuration]) >= self.minDuration) {
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
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        //pause just in case
        if (self.isRecording) {
            [self pauseRecording];
        }
        
        __block NSError *error;
        if([finalVideoLocationURL checkResourceIsReachableAndReturnError:&error]) {
            [subscriber sendError:[NSError errorWithDomain:@"Output file already exists." code:104 userInfo:nil]];
            return nil;
        }
        
        if(self.currentWrites != 0) {
            [subscriber sendError:[NSError errorWithDomain:@"Can't finalize recording unless all sub-recorings are finished." code:106 userInfo:nil]];
            return nil;
        }

        error = nil;
        [self.stitcher reset];
        for (NSURL *outputFileURL in self.temporaryFileURLs) {
            [[self.stitcher addAsset:[AVURLAsset assetWithURL:outputFileURL] transformation:nil] subscribeError:^(NSError *e) {
                error = e;
            }];
        }
        
        if(error) {
            [subscriber sendError:error];
            return nil;
        }
        
        CGSize renderSize = [self.captureSession renderSize];
        [[self.stitcher exportTo:finalVideoLocationURL renderSize:renderSize preset:self.captureSession.exportPreset] subscribeNext:^(NSURL *outputURL) {
            @strongify(self);
            [subscriber sendNext:[outputURL copy]];
        } error:^(NSError *e) {
            [subscriber sendError:e];
        } completed:^{
            [self reset];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal*)totalTimeRecordedSignal {
    return RACObserve(self, currentFinalDurration);
}

- (RACSignal*) recordDurationChangeSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[RACSignal interval:0.01f onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]] subscribeNext:^(id x) {
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
    
    if(error){
        NSLog(@"Error capturing output: %@", error);
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
    self.orientation = AVCaptureVideoOrientationPortrait;
    deviceOrientationDidChangeObserver = [notificationCenter addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        switch ([[UIDevice currentDevice] orientation]) {
            case UIDeviceOrientationPortrait:
                self.orientation = AVCaptureVideoOrientationPortrait;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                self.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            case UIDeviceOrientationLandscapeLeft:
                self.orientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIDeviceOrientationLandscapeRight:
                self.orientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            default:
                self.orientation = AVCaptureVideoOrientationPortrait;
                break;
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

#pragma  mark - Temporary file handling functions
- (NSString *)constructCurrentTemporaryFilename {
    return [NSString stringWithFormat:@"%@%@-%f-%d.mov", NSTemporaryDirectory(), @"recordingsegment", self.uniqueTimestamp, self.currentRecordingSegment];
}

- (void)cleanTemporaryFiles {
    [self.temporaryFileURLs enumerateObjectsUsingBlock:^(NSURL *temporaryFiles, NSUInteger idx, BOOL *stop) {
        [[NSFileManager defaultManager] removeItemAtURL:temporaryFiles error:nil];
    }];
}

@end
