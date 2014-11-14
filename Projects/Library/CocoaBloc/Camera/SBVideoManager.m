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



@end

@implementation SBVideoManager

- (SBAssetStitcher*) stitcher {
    if (!_stitcher)
        _stitcher = [[SBAssetStitcher alloc] init];
    return _stitcher;
}


- (instancetype)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super initWithCaptureSession:session]) {
        _temporaryFileURLs = [[NSMutableArray alloc] init];
        _currentRecordingSegment = 0;
        _isPaused = NO;
        _maxDuration = 0;
        _currentWrites = 0;
        
        self.maxDuration = 10.0;
        self.asyncErrorHandler = ^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        };
        
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        [self startNotificationObservers];
        
        [self setupSessionWithPreset:[self.captureSession bestSessionPreset] withCaptureDevice:AVCaptureDevicePositionBack withTorchMode:AVCaptureTorchModeOff withError:nil completion:nil];
    }
    return self;
}

- (void)dealloc {
    [self.captureSession removeOutput:self.movieFileOutput];
    [self endNotificationObservers];
}

- (void)setupSessionWithPreset:(NSString *)preset withCaptureDevice:(AVCaptureDevicePosition)cd withTorchMode:(AVCaptureTorchMode)tm withError:(void(^)(NSError *error))error completion:(void(^)(void))completion {
    
    if (error == nil) {
        error = ^ (NSError *error) {
            NSLog(@"Error setting up video session - %@", error.localizedDescription);
        };
    }
    
    AVCaptureDevice *captureDevice = [self cameraWithPosition:cd];
    if ([captureDevice hasTorch]) {
        if ([captureDevice lockForConfiguration:nil]) {
            if ([captureDevice isTorchModeSupported:tm]) {
                [captureDevice setTorchMode:AVCaptureTorchModeOff];
            }
            [captureDevice unlockForConfiguration];
        }
    }
    
    self.captureSession.sessionPreset = preset;

    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:nil];
    if([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    } else {
        error([NSError errorWithDomain:@"Error setting video input." code:101 userInfo:nil]);
        return;
    }
    
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
    if([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    } else {
        error([NSError errorWithDomain:@"Error setting audio input." code:101 userInfo:nil]);
        return;
    }
    
    if([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession addOutput:self.movieFileOutput];
    } else {
        error([NSError errorWithDomain:@"Error setting file output." code:101 userInfo:nil]);
        return;
    }
    
    if (completion)
        completion();
}

- (void)startRecording {
    [self.temporaryFileURLs removeAllObjects];
    
    self.uniqueTimestamp = [[NSDate date] timeIntervalSince1970];
    self.currentRecordingSegment = 0;
    _isPaused = NO;
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
    _isPaused = YES;
    [self.movieFileOutput stopRecording];
    
    self.currentFinalDurration = CMTimeAdd(self.currentFinalDurration, self.movieFileOutput.recordedDuration);
}

- (void)resumeRecording {
    self.currentRecordingSegment++;
    _isPaused = NO;
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:[self constructCurrentTemporaryFilename]];
    [self.temporaryFileURLs addObject:outputFileURL];
    
    if(_maxDuration > 0) {
        self.movieFileOutput.maxRecordedDuration = CMTimeSubtract(CMTimeMakeWithSeconds(_maxDuration, 600), self.currentFinalDurration);
    } else {
        self.movieFileOutput.maxRecordedDuration = kCMTimeInvalid;
    }
    
    [self.movieFileOutput startRecordingToOutputFileURL:outputFileURL recordingDelegate:self];
}

- (void)reset {
    if (self.movieFileOutput.isRecording) {
        [self pauseRecording];
    }
    
    _isPaused = NO;
}

- (void)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL completion:(ErrorBlock)completionHandler {
    __weak typeof(self) weakSelf = self;

    CompletionBlock completion = ^ (NSError* error) {
        [weakSelf.stitcher reset];
        if (completionHandler)
            completionHandler(error);
    };
    
    if (completion == nil) completion = ^(NSError*e){};

    [self reset];
    
    NSError *error;
    if([finalVideoLocationURL checkResourceIsReachableAndReturnError:&error]) {
        completion([NSError errorWithDomain:@"Output file already exists." code:104 userInfo:nil]);
        return;
    }
    
    if(self.currentWrites != 0) {
        completion([NSError errorWithDomain:@"Can't finalize recording unless all sub-recorings are finished." code:106 userInfo:nil]);
        return;
    }
    
    __block NSError *stitcherError;
    [self.temporaryFileURLs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSURL *outputFileURL, NSUInteger idx, BOOL *stop) {
        [weakSelf.stitcher addAsset:[AVURLAsset assetWithURL:outputFileURL] transformation:nil error:^(NSError *error) {
            stitcherError = error;
        }];
    }];
    
    if(stitcherError) {
        completion(stitcherError);
        return;
    }
    
    CGSize renderSize = [self.captureSession renderSize];
    [self.stitcher exportTo:finalVideoLocationURL renderSize:renderSize preset:self.captureSession.exportPreset completion:^(NSError *error) {
        if(error) {
            completion(error);
        }
        else {
            [weakSelf cleanTemporaryFiles];
            [weakSelf.temporaryFileURLs removeAllObjects];
            completion(nil);
        }
        
    }];
}

- (CMTime)totalRecordingDuration {
    if(CMTimeCompare(kCMTimeZero, self.currentFinalDurration) == 0) {
        return self.movieFileOutput.recordedDuration;
    }
    else {
        CMTime returnTime = CMTimeAdd(self.currentFinalDurration, self.movieFileOutput.recordedDuration);
        return CMTIME_IS_INVALID(returnTime) ? self.currentFinalDurration : returnTime;
    }
}

#pragma mark - AVCaptureFileOutputRecordingDelegate implementation
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    self.currentWrites++;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if(error){
        if(self.asyncErrorHandler){
            self.asyncErrorHandler(error);
        } else {
            NSLog(@"Error capturing output: %@", error);
        }
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
                        if(self.asyncErrorHandler) {
                            self.asyncErrorHandler(error);
                        } else {
                            NSLog(@"Error reconnecting device input: %@", error);
                        }
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

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    __block AVCaptureDevice *foundDevice = nil;
    [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL *stop) {
        if (device.position == position) {
            foundDevice = device;
            *stop = YES;
        }
    }];
    return foundDevice;
}

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
