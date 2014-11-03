//
//  SCAsset.m
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCAsset.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@import Photos;
@import AssetsLibrary;

@interface SCAsset ()
{
    id _internalObject;
}
@property (nonatomic, strong) NSMutableDictionary *cache;
- (UIImage *)squareImage:(UIImage *)image toSize:(CGSize)size;
@end

@implementation SCAsset

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        _internalObject = object;
        self.cache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (RACSignal *)requestImageWithSize:(CGSize)size;
{
    CGSize imageSize = size;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        if ([_internalObject isKindOfClass:[PHAsset class]]) {
            imageSize = CGSizeMake(((PHAsset *)_internalObject).pixelWidth, ((PHAsset *)_internalObject).pixelWidth);
        }
    }
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (self.cache[[NSValue valueWithCGSize:imageSize]]) {
            UIImage *cached = self.cache[[NSValue valueWithCGSize:imageSize]];
            [subscriber sendNext:cached];
            [subscriber sendCompleted];
        } else {
            if ([_internalObject isKindOfClass:[PHAsset class]]) {
                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                [[PHImageManager defaultManager] requestImageForAsset:_internalObject
                                                           targetSize:imageSize
                                                          contentMode:PHImageContentModeDefault
                                                              options:options
                                                        resultHandler:^(UIImage *result, NSDictionary *info) {
                                                            if ([info[PHImageResultIsDegradedKey] isEqual:@NO] || (!info[PHImageResultIsDegradedKey] && result)) {
                                                                self.cache[[NSValue valueWithCGSize:imageSize]] = result;
                                                                [subscriber sendNext:result];
                                                                [subscriber sendCompleted];
                                                            }
                                                        }];
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
                    UIImage *image = [[UIImage alloc] initWithCGImage:((ALAsset *)_internalObject).defaultRepresentation.fullScreenImage];
                    // do we need to @weakify/@strongify self here?
                    self.cache[[NSValue valueWithCGSize:imageSize]] = image;
                    [subscriber sendNext:image];
                    [subscriber sendCompleted];
                });
            }
        }
        return nil;
    }];
}

- (UIImage *)squareImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:(CGRect){CGPointZero, size}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
