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

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, strong) ALAsset *alAsset;

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

        SBAsset *asset = [[SBAsset alloc] initWithType:type];
        
        asset.location = phAsset.location;
        asset.duration = phAsset.duration;
        asset.phAsset = phAsset;
        [asset setValue:phAsset.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
        [asset setValue:phAsset.modificationDate forKey:NSStringFromSelector(@selector(modificationDate))];
        
        [subscriber sendNext:asset];
        [subscriber sendCompleted];
        
        return nil;
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
        SBAssetType type = SBAssetTypeUnknown;
        NSString *alType = [alAsset valueForProperty:ALAssetPropertyType];
        if ([alType isEqualToString:ALAssetTypePhoto]) type = SBAssetTypeImage;
        else if ([alType isEqualToString:ALAssetTypeVideo]) type = SBAssetTypeVideo;
        
        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
        NSDate *creationDate = [alAsset valueForProperty:ALAssetPropertyDate];
        
        SBAsset *asset = [[SBAsset alloc] initWithType:type];
        
        asset.location = [alAsset valueForProperty:ALAssetPropertyLocation];
        asset.duration = [[alAsset valueForProperty:ALAssetPropertyDuration] floatValue];
        asset.fileURL = [representation url];
        asset.alAsset = alAsset;
        [asset setValue:[creationDate copy] forKey:NSStringFromSelector(@selector(creationDate))];
        [asset setValue:[creationDate copy] forKey:NSStringFromSelector(@selector(modificationDate))];
        
        [subscriber sendNext:asset];
        [subscriber sendCompleted];
        
        return nil;
    }];
}

- (BOOL) localAsset {
    return self.phAsset || self.alAsset;
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
    }
    return self;
}

- (RACSignal*) fetchImage {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (self.image) {
            [subscriber sendNext:self.image];
            [subscriber sendCompleted];
            return nil;
        }
        
        if (self.phAsset) {
            PHImageRequestOptions *options = [PHImageRequestOptions new];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestImageForAsset:self.phAsset targetSize:CGSizeMake(self.phAsset.pixelWidth, self.phAsset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                if ([info[PHImageResultIsDegradedKey] isEqual:@NO] || (!info[PHImageResultIsDegradedKey] && result)) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                }else if (!result) {
                    [subscriber sendError:[NSError errorWithDomain:@"Cannot parse PHAsset" code:101 userInfo:nil]];
                }
            }];
        }
        
        else if (self.alAsset) {
//            [[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] schedule:^{
                ALAssetRepresentation *representation = self.alAsset.defaultRepresentation;
                CGImageRef imageRef = representation.fullScreenImage;
                UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
                
                if (image) {
                    [subscriber sendNext:image];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:@"Cannot create/find image from ALAsset" code:401 userInfo:nil]];
                }
//            }];
        }
        
        else {
            [subscriber sendError:[NSError errorWithDomain:@"No image to fetch" code:101 userInfo:nil]];
        }
        
        return nil;
    }] ;
}

@end
