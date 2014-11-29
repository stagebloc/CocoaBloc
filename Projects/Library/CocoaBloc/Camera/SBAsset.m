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

@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, strong) ALAsset *alAsset;

@property (nonatomic, strong) NSCache *cache;

@end

@implementation SBAsset

- (NSCache*) cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

- (void) setPhAsset:(PHAsset *)photoAsset {
    [self willChangeValueForKey:@"phAsset"];
    _phAsset = photoAsset;
    [self didChangeValueForKey:@"phAsset"];
    
    _pixelHeight = photoAsset.pixelHeight;
    _pixelWidth = photoAsset.pixelWidth;
    
    self.type = (SBAssetType) photoAsset.mediaType;
    
    _creationDate = photoAsset.creationDate;
    _modificationDate = photoAsset.modificationDate;
    
    _location = photoAsset.location;
    _duration = photoAsset.duration;
}

- (void) setAlAsset:(ALAsset *)alAsset {
    [self willChangeValueForKey:@"alAsset"];
    _alAsset = alAsset;
    [self didChangeValueForKey:@"alAsset"];
    
    CGImageRef imageRef = self.alAsset.defaultRepresentation.fullScreenImage;
    _pixelHeight = CGImageGetHeight(imageRef);
    _pixelWidth = CGImageGetWidth(imageRef);
    
    NSString *type = [alAsset valueForKey:ALAssetPropertyType];
    if ([type isEqualToString:ALAssetTypePhoto]) self.type = SBAssetTypeImage;
    else if ([type isEqualToString:ALAssetTypeVideo]) self.type = SBAssetTypeVideo;
    else self.type = SBAssetTypeUnknown;
    
    _creationDate = [alAsset valueForKey:ALAssetPropertyDate];
    _modificationDate = [_creationDate copy];
    
    _location = [alAsset valueForKey:ALAssetPropertyLocation];
    _duration = [[alAsset valueForKey:ALAssetPropertyDuration] floatValue];
}

- (instancetype)initWithPHAsset:(PHAsset*)asset {
    if (self = [super init]) {
        self.phAsset = asset;
    }
    return self;
}

- (instancetype)initWithALAsset:(ALAsset*)asset {
    if (self = [super init]) {
        self.alAsset = asset;
    }
    return self;
}

- (RACSignal*) requestImage {
    return [self requestImageWithSize:CGSizeMake(self.pixelWidth, self.pixelHeight)];
}

- (RACSignal *)requestImageWithSize:(CGSize)imageSize; {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSValue *key = [NSValue valueWithCGSize:imageSize];
        if ([self.cache objectForKey:key]) {
            UIImage *cached = [self.cache objectForKey:key];
            [subscriber sendNext:cached];
            [subscriber sendCompleted];
        } else if (self.phAsset) {
                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestImageForAsset:self.phAsset targetSize:imageSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                if ([info[PHImageResultIsDegradedKey] isEqual:@NO] || (!info[PHImageResultIsDegradedKey] && result)) {
                    [self.cache setObject:result forKey:key];
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                }
            }];
        } else if (self.alAsset) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *image = [[UIImage alloc] initWithCGImage:self.alAsset.defaultRepresentation.fullScreenImage];
                [self.cache setObject:image forKey:key];
                
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            });
        }
        return nil;
    }];
}

@end
