//
//  SCAlbumTableViewCell.h
//  Photo Uploader
//
//  Created by David Warner on 9/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *photoCountLabel;
@property (nonatomic, strong) UIImageView *albumThumbnail;

@end
