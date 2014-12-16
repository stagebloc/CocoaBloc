//
//  SBAssetStitcher.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RACSignal, SBComposition;

@interface SBAssetStitcherOptions : NSObject

@property (nonatomic, assign) AVCaptureVideoOrientation orientation;
@property (nonatomic, copy) NSString *exportPreset;

@property (nonatomic, copy) CGSize (^renderSizeHandler)(SBComposition *composition);

//auto sets renderSize via the exportPreset
//see #import "AVCaptureSession+Extension.h"
+ (instancetype) optionsWithOrientation:(AVCaptureVideoOrientation)orientation
                           exportPreset:(NSString*)exportPreset;

@end

@interface SBAssetStitcher : NSObject
/*
 Resets & clears the current state and it's assets.
 This is not called automatically after exporting.
 So make sure to reset assets before processing a new
 set of assets.
 */
- (void) reset;

- (void)addAsset:(AVURLAsset *)asset devicePosition:(AVCaptureDevicePosition)devicePosition;

- (RACSignal*)exportTo:(NSURL *)outputFileURL options:(SBAssetStitcherOptions *)options;

@end
