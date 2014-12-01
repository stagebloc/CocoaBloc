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

+ (RACSignal*) createGroupFromAssetCollection:(PHAssetCollection*)assetCollection {
    PHFetchOptions *options = [PHFetchOptions new];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", (NSInteger)PHAssetMediaTypeImage];
    // Fetch assets that are only images
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    NSArray *temp = [fetch objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetch.count)]];
    // Filter our fetched assets to only those that aren't "recently deleted"
    temp = [temp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"description contains %@", @"assetSource=3"]];
    return [self createGroupFromPHAssets:temp name:assetCollection.localizedTitle];
}

+ (RACSignal*) createGroupFromAssetGroup:(ALAssetsGroup*)assetGroup {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:assetGroup.numberOfAssets];
        NSMutableArray *signals = [NSMutableArray arrayWithCapacity:assetGroup.numberOfAssets];
        [assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [signals addObject:[SBAsset createAssetFromALAsset:result]];
            }
        }];
        
        [[RACSignal merge:signals] subscribeNext:^(SBAsset *sbAsset) {
            [assets addObject:sbAsset];
        } error:^(NSError *error) {
            NSLog(@"Error creating SBAsset from PHAsset - %@", error);
            [subscriber sendError:error];
        } completed:^{
            SBAssetGroup *group = [[SBAssetGroup alloc] initWithAssets:assets];
            group.name = [assetGroup valueForKey:ALAssetsGroupPropertyName];
            [subscriber sendNext:group];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
}

+ (RACSignal*) createGroupFromPHAssets:(NSArray*)temp name:(NSString*)name {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:temp.count];
        NSMutableArray *signals = [NSMutableArray arrayWithCapacity:temp.count];
        for (PHAsset *a in temp) {
            if (a.burstSelectionTypes == PHAssetBurstSelectionTypeNone)
                [signals addObject:[SBAsset createAssetFromPHAsset:a]];
        }
        
        [[RACSignal merge:signals] subscribeNext:^(SBAsset *sbAsset) {
            [assets addObject:sbAsset];
        } error:^(NSError *error) {
            NSLog(@"Error creating SBAsset from PHAsset - %@", error);
            [subscriber sendError:error];
        } completed:^{
            SBAssetGroup *group = [[SBAssetGroup alloc] initWithAssets:assets];
            group.name = name;
            [subscriber sendNext:group];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
}

- (instancetype)initWithAssets:(NSArray*)assets {
    if (self = [super init]) {
        _assets = [NSSet setWithArray:assets];
    }
    return self;
}

@end
