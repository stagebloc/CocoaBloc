//
//  SCAssetsManager.h
//  StitchCam
//
//  Created by David Warner on 9/23/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@import Photos;
@import AssetsLibrary;

@class SCAssetGroup;

@interface SCAssetsManager : NSObject

+ (SCAssetsManager *)sharedInstance;

-(RACSignal *)fetchLastPhoto;
-(RACSignal *)fetchAlbums;
-(RACSignal *)fetchPhotosForGroup:(SCAssetGroup *)group;

@end
