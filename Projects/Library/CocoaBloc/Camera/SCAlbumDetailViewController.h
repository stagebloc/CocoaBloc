//
//  SCAlbumDetailViewController.h
//  Photo Uploader
//
//  Created by David Warner on 9/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCAssetGroup;

@interface SCAlbumDetailViewController : UICollectionViewController

@property (nonatomic, strong) SCAssetGroup *group;

@end