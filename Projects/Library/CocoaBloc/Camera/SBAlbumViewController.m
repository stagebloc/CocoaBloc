//
//  SCAlbumViewController.m
//  Photo Uploader
//
//  Created by David Warner on 9/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAlbumViewController.h"
#import "SBAlbumDetailViewController.h"
#import "SBAlbumTableViewCell.h"

#import "SBAssetsManager.h"
#import "SBAssetGroup.h"
#import "SBAsset.h"

#import "UIDevice+StageBloc.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@import AssetsLibrary;
@import Photos;

@interface SBAlbumViewController ()

@property (nonatomic, strong) NSArray *albums;

@end

@implementation SBAlbumViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Albums";

    self.tableView.separatorColor = [UIColor clearColor];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:NULL];
    cancel.rac_command = [[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = cancel;
    
    [self.tableView registerClass:[SBAlbumTableViewCell class] forCellReuseIdentifier:@"albumCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[[SBAssetsManager sharedInstance] fetchAlbums] subscribeNext:^(NSArray *albums) {
        self.albums = albums;
        [self.tableView reloadData];
    }];
}

#pragma mark - SCAssetsManager delegate

-(void)fetchAlbumsCompleted
{
    [self.tableView reloadData];
}

#pragma mark - Tableview Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(SBAlbumTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"albumCell";
    SBAlbumTableViewCell *cell = (SBAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SBAssetGroup *group = self.albums[indexPath.row];
    cell.albumNameLabel.text = group.name;
    cell.photoCountLabel.text = [NSString stringWithFormat:@"%ld", group.assets.count];
    cell.albumThumbnail.image = nil;
    [[[[group requestPreviewImageWithSize:90.f] takeUntil:cell.rac_prepareForReuseSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
        cell.albumThumbnail.image = image;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBAlbumDetailViewController *vc = [[SBAlbumDetailViewController alloc] init];
    vc.group = self.albums[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
