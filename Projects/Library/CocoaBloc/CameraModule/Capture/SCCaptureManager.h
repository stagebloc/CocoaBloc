//
//  SCCameraManager.h
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SCCaptureType) {
    SCCaptureTypePhoto,
    SCCaptureTypeVideo
};

#import <Foundation/Foundation.h>

#import "SCPhotoManager.h"
#import "SCVideoManager.h"

@interface SCCaptureManager : NSObject

+ (SCCaptureManager *) sharedInstance;

/**
 * The type of capture we want - either photo or video.
 */
@property (nonatomic, assign) SCCaptureType captureType;
/**
 * The current capture session shared between the photo manager and video manager.
 */
@property (nonatomic, readonly) AVCaptureSession *captureSession;
/**
 * Returns the current device manager being used depending on whether or not we are capturing a photo or recording video
 */
@property (nonatomic, readonly) SCDeviceManager *currentManager;
/**
 * Returns the manager used for capturing photos
 */
@property (nonatomic, readonly) SCPhotoManager *photoManager;
/**
 * Returns the manager used for recording video
 */
@property (nonatomic, readonly) SCVideoManager *videoManager;

//-(void)setPhotoPreset:(AVCaptureSession *)session;


@end
