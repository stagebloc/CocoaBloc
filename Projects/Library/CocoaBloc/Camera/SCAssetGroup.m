//
//  SCAssetGroup.m
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCAssetGroup.h"
#import "SCAsset.h"

@import Photos;
@import AssetsLibrary;

@implementation SCAssetGroup

- (id)initWithAssets:(NSArray *)assets
{
    self = [super init];
    if (self) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:assets.count];
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[PHAsset class]]) {
                if (((PHAsset *)obj).burstSelectionTypes == PHAssetBurstSelectionTypeNone) {
                    [array addObject:[[SCAsset alloc] initWithObject:obj]];
                }
            } else {
                [array addObject:[[SCAsset alloc] initWithObject:obj]];
            }
        }];
        _assets = array;
        _name = @"Camera Roll";
        array = nil;
    }
    return self;
}

- (id)initWithGroup:(id)group
{
    self = [super init];
    if (self) {
        if ([group isKindOfClass:[PHAssetCollection class]]) {
            PHFetchOptions *options = [PHFetchOptions new];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", (NSInteger)PHAssetMediaTypeImage];
            // Fetch assets that are only images
            PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:group options:options];
            NSArray *temp = [fetch objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetch.count)]];
            // Filter our fetched assets to only those that aren't "recently deleted"
            temp = [temp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"description contains %@", @"assetSource=3"]];
            // TODO: Create an array of SCAssets build from PHPhoto objects
            NSMutableArray *assets = [NSMutableArray arrayWithCapacity:temp.count];
            for (PHAsset *a in temp) {
                if (a.burstSelectionTypes == PHAssetBurstSelectionTypeNone) {
                    [assets addObject:[[SCAsset alloc] initWithObject:a]];
                }
            }
            _assets = assets;
            _name = ((PHAssetCollection *)group).localizedTitle;
            temp = nil;
            assets = nil;
        } else {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:((ALAssetsGroup *)group).numberOfAssets];
            [(ALAssetsGroup *)group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                     [temp addObject:[[SCAsset alloc] initWithObject:result]];
                }
            }];
            _assets = temp;
            _name = [((ALAssetsGroup *)group) valueForKey:ALAssetsGroupPropertyName];
            temp = nil;
        }
    }
    return self;
}

- (RACSignal *)requestPreviewImageWithSize:(CGFloat)size
{
    CGFloat pixelSize = size * [UIScreen mainScreen].scale;
    return [(SCAsset *)self.assets.lastObject requestImageWithSize:CGSizeMake(pixelSize, pixelSize)];
}

@end
