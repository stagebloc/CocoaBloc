//
//  SCVideoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//  Source code taken & modified from https://github.com/carsonmcdonald/iOSVideoCameraMultiStitchExample 11/14/2014 - MIT LICENSE
//

#import "SBDeviceManager.h"

@class RACSignal;

typedef void (^ErrorBlock)(NSError *error);

@interface SBVideoManager : SBDeviceManager

@property (nonatomic, assign, readonly) BOOL isPaused;
@property (nonatomic, assign) CGFloat maxDuration;
@property (nonatomic, copy) ErrorBlock asyncErrorHandler;

- (void)startRecording;
- (void)pauseRecording;
- (void)resumeRecording;

- (void)reset;

- (RACSignal*)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL;

- (CMTime)totalRecordingDuration;

@end
