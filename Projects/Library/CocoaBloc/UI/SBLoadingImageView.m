//
//  SBLoadingImageView.m
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBLoadingImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import QuartzCore;
@import CoreGraphics;

@interface SBLoadingImageView ()
@property (nonatomic, assign) BOOL downloading;
@end

@implementation SBLoadingImageView {
    
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)init {
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.drawsProgressStroke = YES;
    self.progressStrokeWidth = 3;
    self.layer.cornerRadius = 50;
    self.layer.borderWidth = 3;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)downloadImageAtURL:(NSURL *)url {
    if (!self.downloading) {
        
        
        self.downloading = YES;
    }
}

- (void)stopDownloading {
    if (self.downloading) {
        
    }
}

@end
