//
//  SBVideoReviewView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBVideoReviewView.h"

@import AVFoundation;

@interface SBVideoReviewView ()

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
    }
    return self;
}

#pragma mark - Notifications 
- (void) playerItemReachedEnd:(NSNotification*)notification {
    NSLog(@"did reach end of video playback");
}

@end
