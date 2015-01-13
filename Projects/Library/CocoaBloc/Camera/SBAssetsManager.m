//
//  SCAssetsManager.m
//  StitchCam
//
//  Created by David Warner on 9/23/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBAssetsManager.h"

#import "SBAssetGroup.h"
#import "SBAsset.h"

#import "UIDevice+StageBloc.h"
#import <ReactiveCocoa/RACEXTScope.h>

#import "ALAssetsLibrary+RAC.h"

@import Photos;
@import AssetsLibrary;

@interface SBAssetsManager ()
@property (nonatomic) ALAssetsLibrary *assetsLibrary;
@end

@implementation SBAssetsManager

- (ALAssetsLibrary*) assetsLibrary {
    if (!_assetsLibrary)
        _assetsLibrary = [ALAssetsLibrary new];
    return _assetsLibrary;
}

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

-(RACSignal *)fetchLastPhoto {
    return [[[self fetchGroupsList] map:^SBAssetGroup*(NSArray *groups) {
        SBAssetGroup *group = [[groups filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name LIKE[c] %@", @"Camera Roll"]] firstObject];
        if (!group)
            group = [groups firstObject];
        return group.assets;
    }] flattenMap:^RACStream *(NSSet *assets) {
        NSArray *array = [assets sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
        SBAsset *asset = array.firstObject;
        return asset.fetchImage;
    }];
}

- (RACSignal*) fetchGroupsList {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSMutableArray *albums = [NSMutableArray array];

        [[self fetchGroups] subscribeNext:^(SBAssetGroup *group) {
            [albums addObject:group];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendNext:[albums copy]];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

-(RACSignal *)fetchGroups {
    
    if ([[UIDevice currentDevice] isAtLeastiOS:8]) {
        if (![PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            return [RACSignal error:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:[PHPhotoLibrary authorizationStatus] userInfo:nil]];
        }
        
        NSMutableArray *signals = [NSMutableArray array];
        
        // Fetch all photos, sort by first created, and filter deleted photos (camera roll album)
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *fetchAllPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        NSArray *tempArray = [fetchAllPhotos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetchAllPhotos.count)]];
        // Filters deleted images
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"description contains %@", @"assetSource=3"];
        NSArray *filteredArray =  [tempArray filteredArrayUsingPredicate:predicate];
        
        [signals addObject:[SBAssetGroup createGroupFromPHAssets:filteredArray name:@"Camera Roll"]];
        
        // Fetch 'smart albums', filter by only ones containing images
        PHFetchResult *fetchSmartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in fetchSmartAlbums) {
            if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumBursts) {
                PHFetchResult *smartAlbumResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if ([smartAlbumResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] > 0) {
                    [signals addObject:[SBAssetGroup createGroupFromAssetCollection:collection]];
                }
            }
        }
        
        // Fetch any user-created albums.
        PHFetchResult *fetchUserAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in fetchUserAlbums) {
            PHFetchResult *userAlbumResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if ([userAlbumResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] > 0) {
                [signals addObject:[SBAssetGroup createGroupFromAssetCollection:collection]];
            }
        }
        
        return [RACSignal merge:signals];
    }

    //ios 7 and lower
    return [[self.assetsLibrary fetchGroupsWithTypes:ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos] flattenMap:^RACStream *(ALAssetsGroup *alGroup) {
        return [SBAssetGroup createGroupFromAssetGroup:alGroup];
    }];
}

@end
