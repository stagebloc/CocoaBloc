//
//  SCPhotoCollectionViewCell.m
//  Photo Uploader
//
//  Created by David Warner on 9/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBPhotoCollectionViewCell.h"

@implementation SBPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}

@end
