//
//  SBVideoPlaybackView.m
//  Pods
//
//  Created by David Warner on 12/4/14.
//
//

#import "SBVideoPlaybackView.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@import AVFoundation;

@interface SBVideoReviewView ()

@property (nonatomic, assign, getter=isPlaying) BOOL playing;

@end

@implementation SBVideoPlaybackView

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

- (void)dealloc {
    self.playerLayer.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
