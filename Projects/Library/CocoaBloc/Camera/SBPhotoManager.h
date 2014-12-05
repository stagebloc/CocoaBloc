//
//  SCPhotoManager.h
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBDeviceManager.h"

@class SBPhotoManager, RACSignal;

@interface SBPhotoManager : SBDeviceManager

//image output
@property (nonatomic, strong) AVCaptureStillImageOutput *output;

//image that was taken
@property (nonatomic, strong) UIImage *image;

/**
 * Captures still image
 */
- (RACSignal*)captureImage;

@end
