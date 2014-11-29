//
//  SCAssetGroup.h
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class ALAssetsGroup, PHAssetCollection;

@interface SBAssetGroup : NSObject

+ (instancetype) groupFromAssetCollection:(PHAssetCollection*)assetCollection;
+ (instancetype) groupFromAssetGroup:(ALAssetsGroup*)assetGroup;
+ (instancetype) groupFromPHAssets:(NSArray*)assets;

/**
 * Initialize an SBAssetGroup with an array of SBAsset objects.
 */
- (instancetype)initWithAssets:(NSArray *)assets;

/**
 * A set of SBAsset objects
 */
@property (nonatomic, readonly) NSSet *assets;

/**
 * The name of the assets group. 
 * It is assumed that if you call initWithAssets, you are building a group from the Camera Roll, so this name will be "Camera Roll"
 */
@property (nonatomic, copy) NSString *name;

@end
