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

/*!
 This class is responsible for handling the video state of the camera
 */
@interface SBVideoManager : SBDeviceManager

@property (nonatomic, assign) CGFloat squareVideoSize;
@property (nonatomic, assign) CGFloat squareVideoOffsetBottom;

@property (nonatomic, assign) CGFloat maxDuration;
@property (nonatomic, assign) CGFloat minDuration;

/*!If there is a recording in session, but just paused.*/
- (BOOL) isPaused;

/*!Starts the recording session. This will reset the state and restart the session.*/
- (void)startRecording;

/*!Pauses the current recording session.*/
- (void)pauseRecording;

/*!Resumes the current recording session*/
- (BOOL)resumeRecording;

/*!Clears the current recording session & any assets that were temporarily saved*/
- (void)reset;

/*!Total time recorded in the current recording session*/
- (CMTime)totalRecordingDuration;

/*!
 @return's YES if past min recording duration.
 */
- (BOOL) isPastMinDuration;

/*!
 @return's YES if the session is currently recording.
 */
- (BOOL) isRecording;

/*!
 @return's a `RACSignal` that sendNext: with the stitched up recording from the current session.
 */
- (RACSignal*)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL;

/*!
 @param `takeUntil` is used to set the current stitch export to cancel upon takeUntil.
 @return's a `RACSignal` that sendNext: with the stitched up recording from the current session.
 */
- (RACSignal*)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL takeUntil:(RACSignal*)takeUntil;

/*!An RACSignal interval that will fire every 0.01f with the updated record time.*/
- (RACSignal*)totalTimeRecordedSignal;

/*!
 Run's every 0.01 of a second with the current CMTime. if the value = nil, then video is paused.
 */
- (RACSignal*)recordDurationChangeSignal;

@end
