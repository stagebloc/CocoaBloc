//
//  SCAsset.h
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CoreLocation/CoreLocation.h>

@class PHAsset, ALAsset, CLLocation;

typedef NS_ENUM(NSUInteger, SBAssetType) {
    SBAssetTypeUnknown = 0,
    SBAssetTypeImage,
    SBAssetTypeVideo,
    SBAssetTypeAudio,
};

/*!
SBAsset is an object containing information on a file either in the file system or in memory. The specific file type can be found via the type property. */
@interface SBAsset : NSObject

/*!
 YES if the asset was created from a PHAsset or ALAsset (createAssetFromPHAsset: & createAssetFromALAsset:)
 NO (Default) if the asset was not created from a PHAsset or ALAsset
 */
@property (nonatomic, readonly) BOOL localAsset;

/*!
 title is set to creationDate's time interval by default.
 */
@property (nonatomic, copy) NSString *title;

/*!
 caption is not set by default.
 */
@property (nonatomic, copy) NSString *caption;

@property (nonatomic, assign) SBAssetType type;

/*!
 File URL that isn't guaranteed to be set for SBAssetTypeImage types
 */
@property (nonatomic, copy) NSURL *fileURL;

/*!
 The date at which the asset was created.
 */
@property(nonatomic, readonly) NSDate *creationDate;

/*!
 The date at which the asset was created.
 */
@property(nonatomic, readonly) NSDate *modificationDate;

/*!
 The location where the asset was captured
 */
@property(nonatomic) CLLocation *location;

/*!
 Duration of the asset if it is a video.
 Duration is always 0 for non videos.
 */
@property(nonatomic, assign) NSTimeInterval duration;

+ (RACSignal*)createAssetFromPHAsset:(PHAsset*)phAsset;
+ (RACSignal*)createAssetFromALAsset:(ALAsset*)alAsset;

- (instancetype) initWithType:(SBAssetType)type;
- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type;
- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type;

//send's UIImage on sendNext:
//send's error if no image can be created/found
//completes after sending image object
- (RACSignal*) fetchImage;
@end
