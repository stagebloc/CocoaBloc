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
 Depending on the @type property, this can be the image
 representation for the SBAssetTypeImage asset or a full 
 resolution thumbnail for a SBAssetTypeVideo.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/*
 File URL that isn't guaranteed to be set for SBAssetTypeImage types
 */
@property (nonatomic, copy, readonly) NSURL *fileURL;

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

+ (RACSignal*)createAssetFromPHAsset:(PHAsset*)phAsset;
+ (RACSignal*)createAssetFromALAsset:(ALAsset*)alAsset;

- (instancetype) initWithType:(SBAssetType)type map:(NSDictionary*)map;

- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type;
- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type map:(NSDictionary*)map;

- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type;
- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type map:(NSDictionary*)map;

@end
