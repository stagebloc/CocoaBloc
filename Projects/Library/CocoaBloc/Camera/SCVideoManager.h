//
//  SCVideoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCDeviceManager.h"
#import "SCCapturing.h"

@interface SCVideoManager : SCDeviceManager <SCCapturing>
/**
 * Video output
 */
@property (nonatomic, strong) AVCaptureMovieFileOutput *output;

/**
 * Mic input
 */
@property (nonatomic, strong) AVCaptureDeviceInput *micInput;

/**
 * Returns an instance of AVCaptureDevice instantiated for the microphone
 */
@property (nonatomic, readonly) AVCaptureDevice *microphone;
/**
 * The current torch mode used by the current camera
 */
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
/**
 * Checks for whether or not the torch is available by the current device
 */
@property (nonatomic, readonly) BOOL isTorchAvailable;
/**
 * Checks whether the torch is active and whether it will be on during video recording
 */
@property (nonatomic, readonly) BOOL isTorchActive;
/**
 * Checks whether or not a specific torh mode is available
 */
- (BOOL)isTorchModeSupported:(AVCaptureTorchMode)torchMode;
/**
 * Sets whether or not to record audio
 */
@property (nonatomic, assign) BOOL shouldRecordAudio;
/**
 * If we overflow the stitch count, reset back to 0 and set the current session as the first recording
 */
@property (nonatomic, assign) BOOL resetsOnOverflow;
/*
 * The FPS of the video recording
 */
@property (nonatomic, assign) CMTime FPS;
/**
 * Whether to stitch videos together or not
 */
@property (nonatomic, assign) BOOL shouldStitchVideo;
/**
 * The amount of videos to stitch together.
 * Set 0 for unlimited.
 */
@property (nonatomic, assign) NSUInteger maximumStitchCount;
/**
 * Returns the current number of videos being stitched together
 */
@property (nonatomic, readonly) NSUInteger currentStitchCount;
/**
 * Maximum duration to record video.
 * If shouldStitchVideo, this will be the total duration of all stitches combined
 * If !shouldStitchVideo, this will be the total duration of a single recorded video
 */
@property (nonatomic, assign) CMTime maxVideoDuration;

/**
 * Called when the camera output has been processed (useful for saving locally).
 */
@property (nonatomic, copy) void (^captureOutputFinishedProcessing)(AVCaptureFileOutput *output, NSURL* fileURL, NSArray *connections, NSError *error);

/**
 * Resets the total stitchings to 0 and deletes all previously recorded stitches
 */
- (void)resetRecordings;
/**
* Starts an output session
*/
- (BOOL)startCapture;
/**
 * Stops an output session
*/
- (void)stopCapture;

/**
 * Save's video locally
 @param completion - [async] called when attempting local save
 @return NO if cannot save locally (stiches == 0)
 @return YES if can save locally (stiches > 0)
 */
- (BOOL) saveVideoLocally:(void (^)(NSURL *assetURL, NSError *error))completion;

@end
