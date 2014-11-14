//
//  SCVideoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBDeviceManager.h"

typedef void (^ErrorHandlingBlock)(NSError *error);

@interface SBVideoManager : SBDeviceManager

@property (nonatomic, assign, readonly) BOOL isPaused;
@property (nonatomic, assign) CGFloat maxDuration;
@property (nonatomic, copy) ErrorHandlingBlock asyncErrorHandler;

- (void)startRecording;
- (void)pauseRecording;
- (void)resumeRecording;

- (void)reset;

- (void)finalizeRecordingToFile:(NSURL *)finalVideoLocationURL withVideoSize:(CGSize)videoSize withPreset:(NSString *)preset withCompletionHandler:(void (^)(NSError *error))completionHandler;

- (CMTime)totalRecordingDuration;

@end
