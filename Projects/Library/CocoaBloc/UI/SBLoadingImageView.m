//
//  SBLoadingImageView.m
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBLoadingImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RACEXTScope.h>

@import QuartzCore;
@import CoreGraphics;

@interface SBLoadingImageView ()
@property (nonatomic, assign) BOOL downloading;
@property (nonatomic, readonly) CAShapeLayer *shapeLayer;
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

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth {
    self.shapeLayer.lineWidth = 3;
}

- (CGFloat)progressStrokeWidth {
    return self.shapeLayer.lineWidth;
}

- (void)setup {
    self.drawsProgressStroke = YES;
    self.progressStrokeWidth = 3;

    self.shapeLayer.masksToBounds = YES; // make sure image doesn't overflow the circle area
    self.shapeLayer.strokeEnd = .5; // no stroke to start with
    self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // make our path a circle
    self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.shapeLayer.strokeColor = self.tintColor.CGColor;
}

- (void)downloadImageAtURL:(NSURL *)url {
    if (self.downloading) return;
    
    self.downloading = YES;
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.shapeLayer.strokeEnd = 1 * ((double)receivedSize / expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.shapeLayer.strokeEnd = 1;
        self.downloading = NO;
    }];
}

@end
