//
//  AVCaptureSession+Extension.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface AVCaptureSession (Extension)

//@return's specific session preset
//not general presets like AVCaptureSessionPresetHigh, etc.
- (NSString*) bestSessionPreset;

- (CGSize) renderSize;
+ (CGSize) renderSizeForSessionPreset:(NSString*)preset;
+ (CGSize) renderSizeForExportPreset:(NSString*)preset;

- (NSString*) exportPreset;
+ (NSString*) exportPresetForSessionPreset:(NSString*)sessionPreset;

@end
