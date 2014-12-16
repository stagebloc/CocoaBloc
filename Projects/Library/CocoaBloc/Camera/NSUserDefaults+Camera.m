//
//  NSUserDefaults+Camera.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "NSUserDefaults+Camera.h"

@implementation NSUserDefaults (Camera)

NSString* const kSBVideoManagerDefaultAspectRatioKey = @"kSBVideoManagerDefaultAspectRatioKey";
NSString* const kSBCaptureManagerDefaultDevicePositionKey = @"kSBCaptureManagerDefaultDevicePositionKey";

+ (void) setAndSaveObject:(NSObject*)object forKey:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

#pragma mark - Aspect Ratio
+ (void) setAspectRatio:(SBCameraAspectRatio)aspectRatio {
    [self setAndSaveObject:[NSNumber numberWithUnsignedInteger:aspectRatio] forKey:kSBVideoManagerDefaultAspectRatioKey];
}
+ (SBCameraAspectRatio) aspectRatio {
    SBCameraAspectRatio defaultRatio =  (SBCameraAspectRatio) [[[NSUserDefaults standardUserDefaults] objectForKey:kSBVideoManagerDefaultAspectRatioKey] unsignedIntegerValue];
    if (defaultRatio != SBCameraAspectRatioSquare && defaultRatio != SBCameraAspectRatioNormal)
        defaultRatio = SBCameraAspectRatioSquare;
    return defaultRatio;
}

#pragma mark - Device Position
+ (void) setDevicePosition:(AVCaptureDevicePosition)devicePosition {
    [self setAndSaveObject:[NSNumber numberWithInteger:devicePosition] forKey:kSBCaptureManagerDefaultDevicePositionKey];
}
+ (AVCaptureDevicePosition) devicePosition {
    AVCaptureDevicePosition position =  (AVCaptureDevicePosition) [[[NSUserDefaults standardUserDefaults] objectForKey:kSBCaptureManagerDefaultDevicePositionKey] integerValue];
    if (position != AVCaptureDevicePositionBack && position != AVCaptureDevicePositionFront)
        position = AVCaptureDevicePositionBack;
    return position;
}

@end
