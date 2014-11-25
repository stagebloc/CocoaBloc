//
//  SBVideoReviewView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBVideoReviewView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@import AVFoundation;

@interface SBVideoReviewView ()

@property (nonatomic, assign, getter=isPlaying) BOOL playing;

@end

@implementation SBVideoReviewView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer*) playerLayer {
    return ((AVPlayerLayer *)self.layer);
}

- (instancetype) initWithFrame:(CGRect)frame videoURL:(NSURL*)videoURL {
    if (self = [super initWithFrame:frame]) {
        NSAssert(videoURL != nil, @"videoURL cannot be nil in SBVideoReviewView.");
        _videoURL = [videoURL copy];
        
        AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        self.playerLayer.player = player;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer.masksToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemReachedEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        
        
        @weakify(self);
        RAC(self, playing) = [RACObserve(self.playerLayer.player, rate) map:^NSNumber*(NSNumber *value) {
            return value.floatValue == 0 ? @NO : @YES;
        }];
        
        [RACObserve(self, playing) subscribeNext:^(NSNumber *playing) {
            if (playing.boolValue)
                self.currentLayout = SBTextFieldLayoutHidden;
        }];
        
        [self.tapSignal subscribeNext:^(UITapGestureRecognizer *gesture) {
            @strongify(self);
            if (self.isPlaying) {
                [self.playerLayer.player pause];
            } else {
                [self.playerLayer.player play];
            }
        }];
        
        [self play];
    }
    return self;
}

#pragma mark - Video State
- (void) play {
    [self.playerLayer.player play];
}

- (void) pause {
    [self.playerLayer.player pause];
}

- (void) restart {
    @weakify(self);
    [self.playerLayer.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        @strongify(self);
        [self.playerLayer.player play];
    }];
}

#pragma mark - Notifications
- (void) playerItemReachedEnd:(NSNotification*)notification {
    [self restart];
}

@end
