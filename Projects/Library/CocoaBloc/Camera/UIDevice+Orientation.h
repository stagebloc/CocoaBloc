//
//  UIDevice+Orientation.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIDevice (Orientation)

+ (AVCaptureVideoOrientation) videoOrientationFrom:(UIDeviceOrientation)deviceOrientation;
- (AVCaptureVideoOrientation) videoOrientation;

+ (UIInterfaceOrientation) interfaceOrientationFrom:(UIDeviceOrientation)deviceOrientation;
- (UIInterfaceOrientation) interfaceOrientation;


- (void) sb_setOrientation:(UIInterfaceOrientation)orientation;
- (void) forceOrientationChange;

+ (double) rotationForInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (double) rotationForInterfaceOrientation;

@end
