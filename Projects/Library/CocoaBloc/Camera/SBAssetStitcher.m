//
//  SBAssetStitcher.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAssetStitcher.h"
#import "AVCaptureSession+Extension.h"
#import "AVAssetExportSession+Extension.h"
#import "SBComposition.h"
#import "NSURL+Camera.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation SBAssetStitcherOptions
+ (instancetype) optionsWithOrientation:(AVCaptureVideoOrientation)orientation
                           exportPreset:(NSString*)exportPreset {
    SBAssetStitcherOptions *options = [[SBAssetStitcherOptions alloc] init];
    options.orientation = orientation;
    options.exportPreset = exportPreset;
    return options;
}

- (instancetype) init {
    if (self = [super init]) {
        self.orientation = AVCaptureVideoOrientationPortrait;
        self.exportPreset = AVAssetExportPresetHighestQuality;
        void (^tempHandler) (SBComposition *comp) = ^(SBComposition *comp) {
            comp.renderSize = comp.naturalSize;
        };
        [self setIndividualCompositionHandler:tempHandler];
        [self setFinalCompositionHandler:tempHandler];
    }
    return self;
}

@end


@interface SBAssetStitcher ()

@property (nonatomic) NSMutableArray *compositionFileURLs; //retains the order
@property (nonatomic) NSMutableArray *compositions;

@end

@implementation SBAssetStitcher

- (instancetype)init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

- (void) reset {
    [self cleanTemporaryAssetFiles];
    self.compositionFileURLs = [[NSMutableArray alloc] init];
    self.compositions = [[NSMutableArray alloc] init];
}

- (void)cleanTemporaryAssetFiles {
    [self.compositionFileURLs enumerateObjectsUsingBlock:^(NSURL *temporaryFiles, NSUInteger idx, BOOL *stop) {
        [[NSFileManager defaultManager] removeItemAtURL:temporaryFiles error:nil];
    }];
    [self.compositions enumerateObjectsUsingBlock:^(SBComposition *comp, NSUInteger idx, BOOL *stop) {
        [[NSFileManager defaultManager] removeItemAtURL:comp.outputURL error:nil];
    }];
}

- (void)addAsset:(AVURLAsset *)asset devicePosition:(AVCaptureDevicePosition)devicePosition{
    SBComposition *comp = [[SBComposition alloc] initWithAsset:asset];
    comp.devicePosition = devicePosition;
    comp.outputURL = [NSURL randomTemporaryMP4FileURLWithPrefix:@"composition"];

    [self.compositionFileURLs addObject:comp.outputURL];
    [self.compositions addObject:comp];
}

- (RACSignal*)exportTo:(NSURL *)outputFileURL options:(SBAssetStitcherOptions *)options {
    NSMutableArray *assetSignals = [NSMutableArray array];
    [self.compositions enumerateObjectsUsingBlock:^(SBComposition *comp, NSUInteger idx, BOOL *stop) {
        comp.orientation = options.orientation;
        comp.exportPreset = options.exportPreset;
        
        if (options.individualCompositionHandler)
            options.individualCompositionHandler(comp);
        
        [assetSignals addObject:comp.createAsset];
    }];
    
    @weakify(self);
    return [[[RACSignal merge:assetSignals] concat:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack* compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack* compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        __block NSError *error = nil;
        [self.compositionFileURLs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSURL *assetURL, NSUInteger idx, BOOL *stop) {
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:assetURL options:nil];
            AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
            AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
            
            [compositionVideoTrack insertTimeRange:timeRange ofTrack:videoTrack atTime:kCMTimeZero error:&error];
            if (!error)
                [compositionAudioTrack insertTimeRange:timeRange ofTrack:audioTrack atTime:kCMTimeZero error:&error];
            
            if(error) *stop = YES;
        }];
        
        if (error) {
            [subscriber sendError:error];
            return nil;
        }
        
        SBComposition *finalComposition = [[SBComposition alloc] initWithAsset:composition];
        finalComposition.outputURL = outputFileURL;
        finalComposition.orientation = AVCaptureVideoOrientationLandscapeRight; //don't rotate this composition
        finalComposition.exportPreset = options.exportPreset;
        
        if (options.finalCompositionHandler)
            options.finalCompositionHandler(finalComposition);
        
        CGFloat squareOffsetBottom = finalComposition.offsetBottom * (options.orientation == AVCaptureVideoOrientationPortraitUpsideDown || options.orientation == AVCaptureVideoOrientationLandscapeLeft ? -1 : 1);
        CGAffineTransform trans;
        CGSize renderSize = finalComposition.renderSize;
        CGSize naturalSize = finalComposition.naturalSize;
        switch (options.orientation) {
            case AVCaptureVideoOrientationPortrait:
            case  AVCaptureVideoOrientationPortraitUpsideDown:
                trans = CGAffineTransformMakeTranslation(0, (-(naturalSize.height-renderSize.height)/2)+squareOffsetBottom);
                break;
            default:
                trans = CGAffineTransformMakeTranslation((-(naturalSize.width-renderSize.width)/2)+squareOffsetBottom, 0);
                break;
        }
        
        AVAssetExportSession *exporter = [finalComposition exporterWithTransform:trans];
        [[exporter exportAsynchronously] subscribe:subscriber];
        return [RACDisposable disposableWithBlock:^{
            [exporter cancelExport];
        }];
    }]] filter:^BOOL(id value) {
        return [value isKindOfClass:[NSURL class]];
    }];
    
}

@end
