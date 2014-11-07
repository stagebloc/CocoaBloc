//
//  SCPhotoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCDeviceManager.h"
#import "SCCapturing.h"

@class SCPhotoManager;

typedef NS_ENUM(NSUInteger, SCCameraAspectRatio) {
    SCCameraAspectRatio1_1 = 0,
    SCCameraAspectRatio4_3 = 1,
};

@protocol SCPhotoManagerDelegate <NSObject>
@optional
-(void)photoManager:(SCPhotoManager*)manager capturedImage:(UIImage*)image;
@end

@interface SCPhotoManager : SCDeviceManager {
    id <SCPhotoManagerDelegate> _delegate;
}

/**
 * PhotoManager delegate
 */
@property (nonatomic,strong) id<SCPhotoManagerDelegate> delegate;
/**
 * The current flash mode used by the current camera
 */
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
/**
 * Image output
 */
@property (nonatomic, strong) AVCaptureStillImageOutput *output;
/**
 * The UIImage output
 */
@property (nonatomic, strong) UIImage *image;

/**
 * Checks whether image output should be 1:1 (square mode) or 4:3 (portrait mode)
 */
@property (nonatomic, assign) SCCameraAspectRatio aspectRatio;
/**
 * Creates the square rect in which to crop the photo
 */
@property (nonatomic, assign) CGRect squareRect;

- (BOOL)isFlashModeAvailable:(AVCaptureFlashMode)flashMode;

/**
 * Captures still image
 */
- (void)captureImage;

@end
