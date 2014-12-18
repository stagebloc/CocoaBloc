//
//  SCPhotoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBDeviceManager.h"

@class SBPhotoManager, RACSignal;

/*!
 This class is responsible for handling the photo state of the camera
 */
@interface SBPhotoManager : SBDeviceManager

/*!image output*/
@property (nonatomic, strong) AVCaptureStillImageOutput *output;

/*!Contains the image that was taken, nil if none*/
@property (nonatomic, strong) UIImage *image;

/**
 * Captures still image
 */
- (RACSignal*)captureImage;

@end
