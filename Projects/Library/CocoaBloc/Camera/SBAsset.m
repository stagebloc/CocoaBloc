//
//  SCAsset.m
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBAsset.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@import Photos;
@import AssetsLibrary;

@interface SBAsset ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation SBAsset

+ (RACSignal*)createAssetFromPHAsset:(PHAsset*)phAsset {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SBAssetType type = SBAssetTypeUnknown;
        switch (phAsset.mediaType) {
            case PHAssetMediaTypeImage: type = SBAssetTypeImage; break;
            case PHAssetMediaTypeVideo: type = SBAssetTypeVideo; break;
            case PHAssetMediaTypeAudio: type = SBAssetTypeAudio; break;
            default: break;
        }
        
        NSDictionary *map = @{
                              @"pixelWidth": @(phAsset.pixelWidth),
                              @"pixelHeight": @(phAsset.pixelHeight),
                              @"creationDate": phAsset.creationDate,
                              @"modificationDate": phAsset.modificationDate,
                              @"location": phAsset.location,
                              @"duration": @(phAsset.duration),
                              };
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if ([info[PHImageResultIsDegradedKey] isEqual:@NO] || (!info[PHImageResultIsDegradedKey] && result)) {
                SBAsset *asset = [[SBAsset alloc] initWithImage:result type:type map:map];
                [subscriber sendNext:asset];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"Cannot parse PHAsset" code:101 userInfo:nil]];
            }
        }];
        return nil;
    }]
            
    flattenMap:^RACStream *(SBAsset *asset) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (asset.type != SBAssetTypeAudio || asset.type != SBAssetTypeVideo) {
                [subscriber sendNext:asset];
                [subscriber sendCompleted];
                return nil;
            }

            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHVideoRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
                if ([avAsset isKindOfClass:[AVURLAsset class]]) {
                    [asset setValue:([(AVURLAsset*)avAsset URL]) forKey:@"fileURL"];
                    [subscriber sendNext:asset];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:@"Cannot get URL from AVAsset" code:101 userInfo:nil]];
                }
            }];
            return nil;
        }];
    }];
}
+ (RACSignal*)createAssetFromALAsset:(ALAsset*)alAsset {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            SBAssetType type = SBAssetTypeUnknown;
            NSString *alType = [alAsset valueForKey:ALAssetPropertyType];
            if ([alType isEqualToString:ALAssetTypePhoto]) type = SBAssetTypeImage;
            else if ([alType isEqualToString:ALAssetTypeVideo]) type = SBAssetTypeVideo;
            
            ALAssetRepresentation *representation = alAsset.defaultRepresentation;
            CGImageRef imageRef = representation.fullScreenImage;
            NSDate *creationDate = [alAsset valueForKey:ALAssetPropertyDate];
            NSDictionary *map = @{
                                  @"pixelWidth": @(CGImageGetWidth(imageRef)),
                                  @"pixelHeight": @(CGImageGetHeight(imageRef)),
                                  @"creationDate": [creationDate copy],
                                  @"modificationDate": [creationDate copy],
                                  @"location": [alAsset valueForKey:ALAssetPropertyLocation],
                                  @"duration": [alAsset valueForKey:ALAssetPropertyDuration],
                                  @"fileURL": [representation url]
                                  };
            UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
            SBAsset *asset = [[SBAsset alloc] initWithImage:image type:type map:map];
            
            [subscriber sendNext:asset];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

- (NSCache*) cache {
    if (!_cache)
        _cache = [[NSCache alloc] init];
    return _cache;
}

- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type map:(NSDictionary*)map {
    if (self = [super init]) {
        _image = image;
        if (map) {
            [map enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [self setValue:obj forKey:key];
            }];
        }
        self.type = SBAssetTypeImage;
    }
    return self;
}

@end
