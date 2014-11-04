//
//  SCAlbumTableViewCell.m
//  Photo Uploader
//
//  Created by David Warner on 9/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SCAlbumTableViewCell.h"
#import <PureLayout/PureLayout.h>


@implementation SCAlbumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _albumThumbnail = [[UIImageView alloc] init];
        _albumThumbnail.backgroundColor = [UIColor blackColor];
        _albumThumbnail.contentMode = UIViewContentModeScaleAspectFill;
        _albumThumbnail.layer.masksToBounds = YES;
        [self addSubview:_albumThumbnail];

        _albumNameLabel = [[UILabel alloc] init];
        _albumNameLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
        [self addSubview:_albumNameLabel];

        _photoCountLabel = [[UILabel alloc] init];
        _photoCountLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        [self addSubview:_photoCountLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat horizontalOffset = 10.f;
    CGFloat verticalOffset = 5.f;
    CGFloat imageViewWidth = CGRectGetHeight(self.contentView.bounds) - 10.f;
    _albumThumbnail.frame = CGRectMake(horizontalOffset, verticalOffset, imageViewWidth, imageViewWidth);

    CGFloat xOffset = (horizontalOffset * 2) + imageViewWidth;

    _albumNameLabel.frame = CGRectMake(xOffset, 25.f, 250.f, self.contentView.frame.size.height/2);
    [_albumNameLabel sizeToFit];

    _photoCountLabel.frame = CGRectMake(xOffset, self.contentView.frame.size.height/2, 250.f, self.contentView.frame.size.height/2);
    [_photoCountLabel sizeToFit];

// Not using purelayout for now since there's goofy shit going on where pre-iOS8 needs vertical offsets to be negative and devices running iOS8 need offsets to be positive

//    [_albumNameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:CGRectGetHeight(self.contentView.bounds)/2];
//    [_albumNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_albumThumbnail withOffset:10.f];
    
//    [_photoCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:CGRectGetHeight(self.contentView.bounds)/2];
//    [_photoCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_albumThumbnail withOffset:10.f];
}

@end
