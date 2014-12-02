//
//  UIDevice+Orientation.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)

- (AVCaptureVideoOrientation) videoOrientation {
    return [UIDevice videoOrientationFrom:[[UIDevice currentDevice] orientation]];
}

+ (AVCaptureVideoOrientation) videoOrientationFrom:(UIDeviceOrientation)deviceOrientation {
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIDeviceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIDeviceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIDeviceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeLeft;
        default:
            return -1;
    }
}

@end
