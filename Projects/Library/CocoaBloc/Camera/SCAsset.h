//
//  SCAsset.h
//  StitchCam
//
//  Created by David Skuza on 10/10/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCAsset : NSObject

/**
 * Initialize an SCAsset object with either a PHAsset or ALAsset
 */
- (instancetype)initWithObject:(id)object;

/**
 * Request an image of the internal asset by size.
 * @param size The size of the image you wish to receive. This parameter will automatically scale to the current screen. Set to CGSizeZero for full resolution.
 */
- (RACSignal *)requestImageWithSize:(CGSize)size;

@end
