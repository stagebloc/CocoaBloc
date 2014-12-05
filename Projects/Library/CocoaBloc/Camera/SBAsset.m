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

        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if ([info[PHImageResultIsDegradedKey] isEqual:@NO] || (!info[PHImageResultIsDegradedKey] && result)) {
                SBAsset *asset = [[SBAsset alloc] initWithImage:result type:type];
                
                asset.pixelHeight = phAsset.pixelHeight;
                asset.pixelWidth = phAsset.pixelWidth;
                asset.location = phAsset.location;
                asset.duration = phAsset.duration;
                [asset setValue:phAsset.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
                [asset setValue:phAsset.modificationDate forKey:NSStringFromSelector(@selector(modificationDate))];
                [asset setValue:@YES forKey:NSStringFromSelector(@selector(localAsset))];
                
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
                    asset.fileURL = ([(AVURLAsset*)avAsset URL]);
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
            
            UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
            SBAsset *asset = [[SBAsset alloc] initWithImage:image type:type];
            asset.pixelWidth = CGImageGetWidth(imageRef);
            asset.pixelHeight = CGImageGetHeight(imageRef);
            asset.location = [alAsset valueForKey:ALAssetPropertyLocation];
            asset.duration = [[alAsset valueForKey:ALAssetPropertyDuration] floatValue];
            asset.fileURL = [representation url];
            [asset setValue:[creationDate copy] forKey:NSStringFromSelector(@selector(creationDate))];
            [asset setValue:[creationDate copy] forKey:NSStringFromSelector(@selector(modificationDate))];
            [asset setValue:@YES forKey:NSStringFromSelector(@selector(localAsset))];

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

- (instancetype) initWithType:(SBAssetType)type {
    if (self = [super init]) {
        _creationDate = [NSDate date];
        _modificationDate = [NSDate date];
        
        self.type = type;
    }
    return self;
}

- (instancetype) initWithFileURL:(NSURL*)url type:(SBAssetType)type{
    if (self = [self initWithType:type]) {
        self.fileURL = [url copy];
    }
    return self;
}

- (instancetype) initWithImage:(UIImage *)image type:(SBAssetType)type {
    if (self = [self initWithType:type]) {
        self.image = image;
        self.pixelHeight = image.size.height;
        self.pixelWidth = image.size.width;
    }
    return self;
}

@end
