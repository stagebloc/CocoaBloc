//
//  SBAssetStitcher.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface SBAssetStitcherOptions : NSObject

@property (nonatomic, assign) AVCaptureVideoOrientation orientation;
@property (nonatomic, assign) CGSize renderSize;
@property (nonatomic, copy) NSString *exportPreset;

+ (instancetype) optionsWithOrientation:(AVCaptureVideoOrientation)orientation
                           exportPreset:(NSString*)exportPreset
                             renderSize:(CGSize)renderSize;

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
