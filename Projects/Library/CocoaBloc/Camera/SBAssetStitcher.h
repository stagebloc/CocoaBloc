//
//  SBAssetStitcher.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//  Source code taken & modified from https://github.com/carsonmcdonald/iOSVideoCameraMultiStitchExample 11/14/2014 - MIT LICENSE
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface SBAssetStitcher : NSObject

@property (nonatomic, assign) AVCaptureVideoOrientation orientation;

- (void) reset;

- (RACSignal*)addAsset:(AVURLAsset *)asset transformation:(CGAffineTransform (^)(AVAssetTrack *videoTrack))transformToApply;

- (RACSignal*)exportTo:(NSURL *)outputFile renderSize:(CGSize)size preset:(NSString *)preset;

@end
