//
//  SBPhotoReviewView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBReviewView.h"

@interface SBPhotoReviewView : SBReviewView <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;

- (instancetype) initWithFrame:(CGRect)frame image:(UIImage*)image;

- (void) setImage:(UIImage*)image;

@end
