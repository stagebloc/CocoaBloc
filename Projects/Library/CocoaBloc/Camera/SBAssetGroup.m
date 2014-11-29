//
//  SCAssetGroup.m
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBAssetGroup.h"
#import "SBAsset.h"

@import Photos;
@import AssetsLibrary;

@implementation SBAssetGroup

+ (instancetype) groupFromAssetCollection:(PHAssetCollection*)assetCollection {
    PHFetchOptions *options = [PHFetchOptions new];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", (NSInteger)PHAssetMediaTypeImage];
    // Fetch assets that are only images
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    NSArray *temp = [fetch objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetch.count)]];
    // Filter our fetched assets to only those that aren't "recently deleted"
    temp = [temp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"description contains %@", @"assetSource=3"]];
    // TODO: Create an array of SCAssets build from PHPhoto objects
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:temp.count];
    for (PHAsset *a in temp) {
        if (a.burstSelectionTypes == PHAssetBurstSelectionTypeNone) {
            [assets addObject:[[SBAsset alloc] initWithPHAsset:a]];
        }
    }
    
    SBAssetGroup *group = [[SBAssetGroup alloc] initWithAssets:assets];
    group.name = assetCollection.localizedTitle;
    return group;
}

+ (instancetype) groupFromAssetGroup:(ALAssetsGroup*)assetGroup {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:assetGroup.numberOfAssets];
    [assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) [temp addObject:[[SBAsset alloc] initWithALAsset:result]];
    }];
    
    SBAssetGroup *group = [[SBAssetGroup alloc] initWithAssets:temp];
    group.name = [assetGroup valueForKey:ALAssetsGroupPropertyName];
    return group;
}

+ (instancetype) groupFromPHAssets:(NSArray*)assets {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:assets.count];
    [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if (asset.burstSelectionTypes == PHAssetBurstSelectionTypeNone) {
            [array addObject:[[SBAsset alloc] initWithPHAsset:asset]];
        }
    }];
    SBAssetGroup *group = [[SBAssetGroup alloc] initWithAssets:array];
    group.name = @"Camera Roll";
    return group;
}

- (instancetype)initWithAssets:(NSArray*)assets {
    if (self = [super init]) {
        _assets = [NSSet setWithArray:assets];
    }
    return self;
}

@end
