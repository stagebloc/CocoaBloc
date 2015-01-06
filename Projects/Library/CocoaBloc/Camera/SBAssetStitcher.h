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

//use these to set specific attributes to the compositions.
@property (nonatomic, copy) void (^individualCompositionHandler)(SBComposition *composition);
@property (nonatomic, copy) void (^finalCompositionHandler)(SBComposition *composition);

//auto sets renderSize via the exportPreset
//see #import "AVCaptureSession+Extension.h"
+ (instancetype) optionsWithOrientation:(AVCaptureVideoOrientation)orientation
                           exportPreset:(NSString*)exportPreset;

@end

@interface SBAssetStitcher : NSObject
/*!
 Resets & clears the current state and it's assets. This is not called automatically after exporting. So make sure to reset assets before processing a new set of assets.
 This will also clear any local asset files from disc.
 */
- (void) reset;

/*!
 Add's an asset to be processed later on export.
 */
- (void)addAsset:(AVURLAsset *)asset devicePosition:(AVCaptureDevicePosition)devicePosition;

/*!
 Exports currently added assets to the `outputFileURL` with the `specified` options
 */
- (RACSignal*)exportTo:(NSURL *)outputFileURL options:(SBAssetStitcherOptions *)options;

@end
