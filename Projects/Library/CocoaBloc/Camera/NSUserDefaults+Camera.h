//
//  NSUserDefaults+Camera.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SBDeviceManager.h"

@interface NSUserDefaults (Camera)

extern NSString* const kSBVideoManagerDefaultAspectRatioKey;
extern NSString* const kSBCaptureManagerDefaultDevicePositionKey;

+ (void) setAspectRatio:(SBCameraAspectRatio)aspectRatio;
+ (SBCameraAspectRatio) aspectRatio;

+ (void) setDevicePosition:(AVCaptureDevicePosition)devicePosition;
+ (AVCaptureDevicePosition) devicePosition;

@end
