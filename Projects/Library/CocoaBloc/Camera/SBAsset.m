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
        
        RACDisposable *disposable = [[RACDisposable alloc] init];
        
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
                              @"location": phAsset.location == nil ? [NSNull null] : phAsset.location,
                              @"duration": @(phAsset.duration),
                              };
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if ([info[PHImageResultIsDegradedKey] isEqual:@NO] || (!info[PHImageResultIsDegradedKey] && result)) {
                SBAsset *asset = [[SBAsset alloc] initWithImage:result type:type map:map];
                [subscriber sendNext:asset];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"Cannot parse PHAsset" code:101 userInfo:nil]];
            }
            [disposable dispose];
        }];
        return disposable;
    }]
            
    flattenMap:^RACStream *(SBAsset *asset) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (asset.type != SBAssetTypeAudio || asset.type != SBAssetTypeVideo) {
                [subscriber sendNext:asset];
                [subscriber sendCompleted];
                return nil;
            }

            RACDisposable *disposable = [[RACDisposable alloc] init];
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
                [disposable dispose];
            }];
            return disposable;
        }];
    }];
}
+ (RACSignal*)createAssetFromALAsset:(ALAsset*)alAsset {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[RACDisposable alloc] init];

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
            [disposable dispose];
        });
        return disposable;
    }];
}

- (NSCache*) cache {
    if (!_cache)
        _cache = [[NSCache alloc] init];
    return _cache;
}

- (NSDictionary*) defaultMap {
    return @{
             NSStringFromSelector(@selector(creationDate)) : [NSDate date],
             NSStringFromSelector(@selector(modificationDate)) : [NSDate date],
             NSStringFromSelector(@selector(title)) : [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]
             };
}

- (instancetype) initWithType:(SBAssetType)type map:(NSDictionary*)map {
    if (self = [super init]) {
        NSDictionary *defaultMap = [self defaultMap];
        [defaultMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:obj forKey:key];
        }];
        
        if (map) {
            [map enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [self setValue:obj forKey:key];
            }];
        }
        
        self.type = type;
    }
    return self;
}

- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type {
    return [self initWithFileURL:url type:type map:nil];
}
- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type map:(NSDictionary*)map{
    if (self = [self initWithType:type map:map]) {
        _fileURL = [url copy];
    }
    return self;
}

- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type {
    return [self initWithImage:image type:type map:nil];
}
- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type map:(NSDictionary*)map {
    if (self = [self initWithType:type map:map]) {
        _image = image;
        
        if ([map objectForKey:NSStringFromSelector(@selector(pixelHeight))] == nil)
            _pixelHeight = image.size.height;
        if ([map objectForKey:NSStringFromSelector(@selector(pixelWidth))] == nil)
            _pixelWidth = image.size.width;
    }
    return self;
}

@end
