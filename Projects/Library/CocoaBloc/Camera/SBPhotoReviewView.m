//
//  SBPhotoReviewView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBPhotoReviewView.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation SBPhotoReviewView

- (instancetype) initWithFrame:(CGRect)frame image:(UIImage*)image {
    if (self = [super initWithFrame:frame]) {
        //image view
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // Screen aspect ratio / image aspect ratio x screen width -> fit image height to screen and set scrollview content width
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 4.0;
        self.scrollView.zoomScale = 1;
        self.scrollView.contentSize = self.scrollView.frame.size;

        [self insertSubview:self.scrollView atIndex:0];
        [self.scrollView autoCenterInSuperview];
        [self.scrollView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
        [self.scrollView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        
        [self.scrollView addSubview:self.imageView];
        [self.imageView autoCenterInSuperview];
        [self.imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
        [self.imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
