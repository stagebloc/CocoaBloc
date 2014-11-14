//
//  SCAlbumDetailViewController.m
//  Photo Uploader
//
//  Created by David Warner on 9/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAlbumDetailViewController.h"
#import "SBImagePickerController.h"

#import "SBPhotoCollectionViewCell.h"

#import "SBAssetsManager.h"
#import "SBAsset.h"

#import "UIDevice+StageBloc.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#define CELL_SIZE 78

@interface SBAlbumDetailViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *assets;
@end

@implementation SBAlbumDetailViewController

- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2.0f;
    layout.minimumLineSpacing = 2.0f;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[SBPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"albumCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[[SBAssetsManager sharedInstance] fetchPhotosForGroup:self.group] subscribeNext:^(NSArray *photos) {
        self.assets = photos;
        [self.collectionView reloadData];
    }];
}

- (SBPhotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SBPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    SBAsset *asset = self.assets[indexPath.row];
    CGFloat pixelSize = 78.f * [UIScreen mainScreen].scale;
    [[[[asset requestImageWithSize:CGSizeMake(pixelSize, pixelSize)] takeUntil:cell.rac_prepareForReuseSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(78, 78);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SBAsset *asset = self.assets[indexPath.row];
    [[[asset requestImageWithSize:CGSizeZero] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(UIImage *image) {
        // TODO: I'm not sure this is how we want to pass on images - perhaps a .selectedImage property and a completion RACCommand? Or can we pipe this through somehow?
        if ([self.navigationController isKindOfClass:[SBImagePickerController class]]) {
            if (((SBImagePickerController *)self.navigationController).completionBlock) {
                ((SBImagePickerController *)self.navigationController).completionBlock(image, nil);
            }
        }
    }];
}

@end
