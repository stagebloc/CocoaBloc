//
//  SBComposition.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface SBComposition : NSObject

@property (nonatomic, assign) AVCaptureVideoOrientation orientation;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;
@property (nonatomic, assign) CGSize renderSize;
@property (nonatomic, copy) NSString *exportPreset;
@property (nonatomic, copy) NSURL *outputURL;

@property (nonatomic, readonly, strong) AVURLAsset *asset;

- (instancetype)initWithAsset:(AVURLAsset*)asset;

- (RACSignal*) fetchAsset;

@end
