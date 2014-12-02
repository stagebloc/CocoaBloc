//
//  UIDevice+Orientation.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface UIDevice (Orientation)

+ (AVCaptureVideoOrientation) videoOrientationFrom:(UIDeviceOrientation)deviceOrientation;
- (AVCaptureVideoOrientation) videoOrientation;

@end