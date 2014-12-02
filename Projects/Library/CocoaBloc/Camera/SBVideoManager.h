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

@interface SBVideoManager : SBDeviceManager

@property (nonatomic, assign) CGFloat maxDuration;
@property (nonatomic, assign) CGFloat minDuration;

- (BOOL) isPaused;

- (void)startRecording;
- (void)pauseRecording;
- (BOOL)resumeRecording;

- (void)reset;

- (CMTime)totalRecordingDuration;
- (BOOL) isPastMinDuration;
- (BOOL) isRecording;

- (RACSignal*)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL;
- (RACSignal*)totalTimeRecordedSignal;

/*
 Run's every 0.01 of a second with the current CMTime.
 if the value = nil, then video is paused.
 */
- (RACSignal*)recordDurationChangeSignal;

@end
