//
//  SCAssetGroup.h
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCAssetGroup : NSObject

/**
 * Initialize an SCAssetGroup with an array of either PHAssets or ALAssets.
 * This will automatically create an internal array of SCAssets that can then be accessed.
 */
- (id)initWithAssets:(NSArray *)assets;
/**
 * Initialize an SCAssetGroup with either a PHAssetCollection or ALAssetGroup.
 * This will automatically create an internal array of SCAssets that can then be accessed.
 */
- (id)initWithGroup:(id)group;

/**
 * An array of SCAsset objects
 * @warning This will be nil unless the object was initialized using initWithAssets
 */
@property (nonatomic, readonly) NSArray *assets;

/**
 * The name of the assets group. 
 * It is assumed that if you call initWithAssets, you are building a group from the Camera Roll, so this name will be "Camera Roll"
 */
@property (nonatomic, readonly) NSString *name;

/**
 * Request an image that depicts a preview of an asset group by size.
 * @param size The width and height of the thumbnail image you want to obtain. This will automatically be scaled appropriately to the current screen.
 */
- (RACSignal *)requestPreviewImageWithSize:(CGFloat)size;

@end
