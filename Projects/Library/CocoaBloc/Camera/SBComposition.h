//
//  SBComposition.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface SBComposition : NSObject

//The desired export orientation of this asset
@property (nonatomic, assign) AVCaptureVideoOrientation orientation;

//Device position the asset was constructed at
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

//The export preset. See #import "AVCaptureSession+Extension.h" for more help
@property (nonatomic, copy) NSString *exportPreset;

//Where the new asset will be saved to
@property (nonatomic, copy) NSURL *outputURL;

//DEFAULT is the asset's videoTrack naturalSize.
@property (nonatomic, assign) CGSize renderSize;

//natural height of the original asset
@property (nonatomic, readonly, assign) CGSize naturalSize;

//offset the bottom translation
//default is 0, no offset translation
@property (nonatomic, assign) CGFloat offsetBottom;

//Original asset that is being manipulated
@property (nonatomic, readonly, strong) AVAsset *asset;

- (instancetype)initWithAsset:(AVAsset*)asset;


/*
 It's reccomended to use the createAsset RACSignal.
 Use this premade exporter session if you really know
 what you're doing.
 
 Calls exporterWithTransform: with the default transform (transformFromRenderSize:)
 */
- (AVAssetExportSession*) exporter;

//Same as exporter but with a custom transform.
- (AVAssetExportSession*) exporterWithTransform:(CGAffineTransform)transform;


/*
 Creates a new asset based on SBComposition's properties.
 sendNext: is an AVURLAsset created at SBComposition's outputURL
 Creates an RACSignal from exporter method.
 */
- (RACSignal*) createAsset;

@end