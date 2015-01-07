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


+ (UIInterfaceOrientation) interfaceOrientationFrom:(UIDeviceOrientation)deviceOrientation {
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            return UIInterfaceOrientationPortrait;
        case UIDeviceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationPortraitUpsideDown;
        case UIDeviceOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeLeft;
        case UIDeviceOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeRight;
        default:
            return -1;
    }
}
- (UIInterfaceOrientation) interfaceOrientation {
    return [UIDevice interfaceOrientationFrom:[[UIDevice currentDevice] orientation]];
}

- (void) sb_setOrientation:(UIInterfaceOrientation)orientation {
    [self setValue:@(orientation) forKey:NSStringFromSelector(@selector(orientation))];
}

- (void) forceOrientationChange {
    NSInteger orientation = [[UIDevice currentDevice] interfaceOrientation];
    if (orientation != -1) {
        [self sb_setOrientation:orientation];
    }
}

+ (double) rotationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            return M_PI;
        case UIInterfaceOrientationLandscapeLeft:
            return M_PI_2;
        case UIInterfaceOrientationLandscapeRight:
            return -M_PI_2;
        default:
            return 0;
    }
}

- (double) rotationForInterfaceOrientation {
    return [UIDevice rotationForInterfaceOrientation:[self interfaceOrientation]];
}



@end
