//
//  SBAssetStitcher.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SBAssetStitcher : NSObject

- (instancetype)initWithOutputSize:(CGSize)outSize;

- (void)addAsset:(AVURLAsset *)asset withTransform:(CGAffineTransform (^)(AVAssetTrack *videoTrack))transformToApply withErrorHandler:(void (^)(NSError *error))errorHandler;
- (void)exportTo:(NSURL *)outputFile withPreset:(NSString *)preset withCompletionHandler:(void (^)(NSError *error))completed;

@end
