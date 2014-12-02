//
//  AVCaptureSession+Extension.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVCaptureSession (Extension)

- (NSString*) bestSessionPreset;

- (CGSize) renderSize;

- (NSString*) exportPreset;

@end
