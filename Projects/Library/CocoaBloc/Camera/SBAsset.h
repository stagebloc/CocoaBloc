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

//title is set to creationDate's time interval by default.
@property (nonatomic, copy) NSString *title;

//caption is not set by default.
@property (nonatomic, copy) NSString *caption;

@property (nonatomic, assign) SBAssetType type;

/*
 Depending on the @type property, this can be the image
 representation for the SBAssetTypeImage asset or a full 
 resolution thumbnail for a SBAssetTypeVideo.
 */
@property (nonatomic, strong) UIImage *image;

/*
 File URL that isn't guaranteed to be set for SBAssetTypeImage types
 */
@property (nonatomic, copy) NSURL *fileURL;

/*
 The pixel width/height of the asset.
 This may or amy not be set.
 */
@property(nonatomic, assign) NSUInteger pixelWidth;
@property(nonatomic, assign) NSUInteger pixelHeight;

@property(nonatomic, strong, readonly) NSDate *creationDate;
@property(nonatomic, strong, readonly) NSDate *modificationDate;

/*
 The location where the asset was captured
 */
@property(nonatomic, strong) CLLocation *location;

/*
 Duration of the asset if it is a video.
 Duration is always 0 for non videos.
 */
@property(nonatomic, assign) NSTimeInterval duration;

+ (RACSignal*)createAssetFromPHAsset:(PHAsset*)phAsset;
+ (RACSignal*)createAssetFromALAsset:(ALAsset*)alAsset;

- (instancetype) initWithType:(SBAssetType)type;
- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type;
- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type;
@end
