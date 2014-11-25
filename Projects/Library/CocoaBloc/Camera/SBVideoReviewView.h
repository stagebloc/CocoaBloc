//
//  SBVideoReviewView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBReviewView.h"

@interface SBVideoReviewView : SBReviewView

@property (nonatomic, readonly, copy) NSURL *videoURL;

- (instancetype) initWithFrame:(CGRect)frame videoURL:(NSURL*)videoURL;

- (void) play;
- (void) pause;
- (void) restart;

@end
