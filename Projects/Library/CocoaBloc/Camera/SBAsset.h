//
//  SCAsset.h
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@import CoreLocation;

@class PHAsset, ALAsset;

typedef NS_ENUM(NSUInteger, SBAssetType) {
    SBAssetTypeUnknown = 0,
    SBAssetTypeImage,
    SBAssetTypeVideo,
    SBAssetTypeAudio,
};

@interface SBAsset : NSObject

@property (nonatomic, assign) SBAssetType type;

/*
 The pixel width/height of the asset.
 This may or amy not be set until 
 */
@property(nonatomic, assign, readonly) NSUInteger pixelWidth;
@property(nonatomic, assign, readonly) NSUInteger pixelHeight;

@property(nonatomic, strong, readonly) NSDate *creationDate;
@property(nonatomic, strong, readonly) NSDate *modificationDate;

/*
 The location where the asset was captured
 */
@property(nonatomic, strong, readonly) CLLocation *location;

/*
 Duration of the asset if it is a video.
 Duration is always 0 for non videos.
 */
@property(nonatomic, assign, readonly) NSTimeInterval duration;

/**
 * Initialize an SCAsset object with either a PHAsset or ALAsset
 */
- (instancetype)initWithPHAsset:(PHAsset*)asset;
- (instancetype)initWithALAsset:(ALAsset*)asset;

- (RACSignal*) requestImage;
- (RACSignal*) requestImageWithSize:(CGSize)imageSize;

@end
