//
//  SCAlbumTableViewCell.h
//  Photo Uploader
//
//  Created by David Warner on 9/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAlbumTableViewCell : UITableViewCell

@property (nonatomic) UILabel *albumNameLabel;
@property (nonatomic) UILabel *photoCountLabel;
@property (nonatomic) UIImageView *albumThumbnail;

@end
