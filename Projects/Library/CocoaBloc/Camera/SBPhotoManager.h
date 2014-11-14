//
//  SCPhotoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBDeviceManager.h"

@class SBPhotoManager;

typedef NS_ENUM(NSUInteger, SBCameraAspectRatio) {
    SBCameraAspectRatio1_1 = 0,
    SBCameraAspectRatio4_3 = 1,
};

@interface SBPhotoManager : SBDeviceManager

//image output
@property (nonatomic, strong) AVCaptureStillImageOutput *output;

//image that was taken
@property (nonatomic, strong) UIImage *image;

/**
 * Checks whether image output should be 1:1 (square mode) or 4:3 (portrait mode)
 */
@property (nonatomic, assign) SBCameraAspectRatio aspectRatio;

/**
 * Captures still image
 */
- (void)captureImageWithCompletion:(void(^)(UIImage* image))completion;

@end
