//
//  SCAssetsManager.m
//  StitchCam
//
//  Created by David Warner on 9/23/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCAssetsManager.h"

#import "SCAssetGroup.h"
#import "SCAsset.h"

#import "UIDevice+StageBloc.h"

@interface SCAssetsManager ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@end

@implementation SCAssetsManager

+ (SCAssetsManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static SCAssetsManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SCAssetsManager new];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![[UIDevice currentDevice] isAtLeastiOS:8]) {
            self.assetsLibrary = [ALAssetsLibrary new];
        }
    }
    return self;
}

-(RACSignal *)fetchLastPhoto
{
    // TODO: Error handling
     return [[[[self fetchAlbums]
            map:^SCAssetGroup * (NSArray *albums) {
                SCAssetGroup *group = nil;
                for (NSInteger i = 0; i < albums.count; i++) {
                    SCAssetGroup *g = albums[i];
                    if ([g.name isEqualToString:@"Camera Roll"]) {
                        group = g;
                        break;
                    }
                }
                return group;
            }]
            flattenMap:^RACStream *(SCAssetGroup *group) {
                return [self fetchPhotosForGroup:group];
            }]
            flattenMap:^RACStream *(NSArray *assets) {
                return [((SCAsset *)assets[0]) requestImageWithSize:CGSizeZero];
            }];
}

-(RACSignal *)fetchAlbums
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([[UIDevice currentDevice] isAtLeastiOS:8]) {
            if (![PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
                // TODO: Improve returned error
                [subscriber sendError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:[PHPhotoLibrary authorizationStatus] userInfo:nil]];
            } else {
                NSMutableArray *albums = [NSMutableArray arrayWithCapacity:0];
                // Fetch all photos, sort by first created, and filter deleted photos (camera roll album)
                PHFetchOptions *fetchOptions = [PHFetchOptions new];
                fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                PHFetchResult *fetchAllPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
                NSArray *tempArray = [fetchAllPhotos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetchAllPhotos.count)]];
                // Filters deleted images
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"description contains %@", @"assetSource=3"];
                NSArray *filteredArray =  [tempArray filteredArrayUsingPredicate:predicate];
                [albums addObject:[[SCAssetGroup alloc] initWithAssets:filteredArray]];
                
                // Fetch 'smart albums', filter by only ones containing images
                PHFetchResult *fetchSmartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                for (PHAssetCollection *collection in fetchSmartAlbums) {
                    if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumBursts) {
                        PHFetchResult *smartAlbumResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                        if ([smartAlbumResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] > 0) {
                            [albums addObject:[[SCAssetGroup alloc] initWithGroup:collection]];
                        }
                    }
                }
                
                // Fetch any user-created albums.
                PHFetchResult *fetchUserAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                for (PHAssetCollection *collection in fetchUserAlbums) {
                    PHFetchResult *userAlbumResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if ([userAlbumResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] > 0) {
                        [albums addObject:[[SCAssetGroup alloc] initWithGroup:collection]];
                    }
                }
                
                [subscriber sendNext:albums];
                [subscriber sendCompleted];
            }
        } else {
            NSMutableArray *albums = [NSMutableArray arrayWithCapacity:0];
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos
                                              usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                  [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                                  if (albums) {
                                                      if ([group numberOfAssets] > 0) {
                                                          [albums addObject:[[SCAssetGroup alloc] initWithGroup:group]];
                                                      }
                                                  } else {
                                                      [subscriber sendNext:albums];
                                                      [subscriber sendCompleted];
                                                  }
                                              }
                                            failureBlock:^(NSError *error) {
                                                [subscriber sendError:error];
                                            }];
        }
        return nil;
    }];
}

-(RACSignal *)fetchPhotosForGroup:(SCAssetGroup *)group
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:group.assets];
        return nil;
    }];
}


@end
