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

@interface SBAssetsManager ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
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
    return [[[self fetchAlbumsArray] map:^id(NSArray *albums) {
        SBAssetGroup *group = nil;
        for (NSInteger i = 0; i < albums.count; i++) {
            SBAssetGroup *g = albums[i];
            if ([g.name isEqualToString:@"Camera Roll"]) {
                group = g;
                break;
            }
        }
        return group.assets;
    }] map:^RACStream *(NSSet *assets) {
        NSArray *array = [assets sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
        SBAsset *asset = array.firstObject;
        return asset.image;
    }];
}

- (RACSignal*) fetchAlbumsArray {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[RACDisposable alloc] init];
        NSMutableArray *albums = [NSMutableArray array];

        [[self fetchAlbums] subscribeNext:^(SBAssetGroup *group) {
            [albums addObject:group];
        } error:^(NSError *error) {
            [subscriber sendError:error];
            [disposable dispose];
        } completed:^{
            [subscriber sendNext:[albums copy]];
            [subscriber sendCompleted];
            [disposable dispose];
        }];
        
        return disposable;
    }];
}

-(RACSignal *)fetchAlbums {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[RACDisposable alloc] init];

        NSMutableArray *signals = [NSMutableArray array];

        if ([[UIDevice currentDevice] isAtLeastiOS:8]) {
            if (![PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
                // TODO: Improve returned error
                [subscriber sendError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:[PHPhotoLibrary authorizationStatus] userInfo:nil]];
                return nil;
            }
            
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
            
        }
        
        //ios 7 and lower
        else {
            NSMutableArray *albums = [NSMutableArray array];
            __block NSError *error = nil;
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if (group && [group numberOfAssets] > 0)
                    [signals addObject:[SBAssetGroup createGroupFromAssetGroup:group]];
            } failureBlock:^(NSError *e) {
                error = e;
            }];
            if (error) {
                [subscriber sendError:error];
                return nil;
            }
        }
        
        [[RACSignal merge:signals] subscribeNext:^(SBAssetGroup *group) {
            [subscriber sendNext:group];
        } error:^(NSError *error) {
            [subscriber sendError:error];
            [disposable dispose];
        } completed:^{
            [subscriber sendCompleted];
            [disposable dispose];
        }];
        
        return disposable;
    }];
}

@end
