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
-(void)imageCaptureCompleted;

@end

@interface SCPhotoManager : SCDeviceManager {
    id <SCPhotoManagerDelegate> _delegate;
}

/**
 * PhotoManager delegate
 */
@property (nonatomic,strong) id delegate;
/**
 * The current flash mode used by the current camera
 */
@property (nonatomic, assign) AVCaptureFlashMode *flashMode;
/**
 * Image output
 */
@property (nonatomic, strong) AVCaptureStillImageOutput *output;
/**
 * The UIImage output
 */
@property (nonatomic, assign) UIImage *image;
/**
 * Checks for whether or not flash is available by the current device
 */
@property (nonatomic, readonly) BOOL isFlashAvailable;
/**
 * Checks whether the flash is active and whether it will flash when taking a photo
 */
@property (nonatomic, readonly) BOOL isFlashActive;
/**
 * Checks whether image output should be 1:1 (square mode) or 4:3 (portrait mode)
 */
@property (nonatomic, assign) BOOL aspectRatioDefault;
/**
 * Creates the square rect in which to crop the photo
 */
@property (nonatomic, assign) CGRect squareRect;

- (BOOL)isFlashModeAvailable:(AVCaptureFlashMode)flashMode;
/**
* Checks whether or not flash is active
*/
- (BOOL)isFlashModeActive:(AVCaptureFlashMode)flashMode;
/**
 * Captures still image
 */
- (void)captureImage;
/**
* Toggles the aspect ratio between 4:3 and 1:1
*/
- (BOOL)toggleAspectRatio;









@end
