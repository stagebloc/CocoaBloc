//
//  SBAssetStitcher.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface SBAssetStitcher : NSObject

@property (nonatomic, assign) AVCaptureVideoOrientation orientation;

/*
 Resets & clears the current state and it's assets.
 This is not called automatically after exporting.
 So make sure to reset assets before processing a new
 set of assets.
 */
- (void) reset;

- (RACSignal*)addAsset:(AVURLAsset *)asset;

- (RACSignal*)exportTo:(NSURL *)outputFileURL preset:(NSString *)preset;
- (RACSignal*)exportTo:(NSURL *)outputFileURL preset:(NSString *)preset square:(BOOL)isSquare;

@end
