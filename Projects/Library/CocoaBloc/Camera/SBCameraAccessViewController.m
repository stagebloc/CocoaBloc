//
//  SBCameraAccessViewController.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBCameraAccessViewController.h"
#import "UIFont+FanClub.h"
#import "UIView+Extension.h"
#import "UIDevice+StageBloc.h"

#import <AVFoundation/AVFoundation.h>
#import <PureLayout/PureLayout.h>

@interface SBCameraAccessViewController ()

@end

@implementation SBCameraAccessViewController

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Camera permissions are required";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fc_lightFontWithSize:24];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton*) detailsButton {
    if (!_detailsButton) {
        _detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailsButton.titleLabel.font = [UIFont fc_fontWithSize:16];
        _detailsButton.titleLabel.numberOfLines = 0;
        _detailsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_detailsButton setTitleColor:[UIColor colorWithWhite:0.85 alpha:1] forState:UIControlStateNormal];
        [_detailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        BOOL enabled = [self canOpenSettings];
        [_detailsButton setTitle:enabled ? @"Open settings" : @"Open Settings: Privacy: Camera and turn on camera access" forState:UIControlStateNormal];
        _detailsButton.enabled = enabled;
        [_detailsButton addTarget:self action:@selector(openSettingsPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailsButton;

}

- (UIButton*) dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.titleLabel.font = [UIFont fc_fontWithSize:12];
        [_dismissButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_dismissButton setTitle:@"close" forState:UIControlStateNormal];
    }
    return _dismissButton;
}

- (BOOL) canOpenSettings {
    return (&UIApplicationOpenSettingsURLString != NULL);
}

- (void) setMediaType:(NSString *)mediaType {
    [self willChangeValueForKey:@"mediaType"];
    _mediaType = [mediaType copy];
    [self didChangeValueForKey:@"mediaType"];
    
    if ([mediaType isEqualToString:AVMediaTypeAudio]) {
        self.titleLabel.text = @"Audio permissions are required";
    } else {
        self.titleLabel.text = @"Camera permissions are required";
    }
}

- (instancetype) initWithMediaTypeDenied:(NSString*)mediaType {
    if (self = [super init]) {
        self.mediaType = mediaType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = CGSizeMake(280, [self canOpenSettings] ? 20 : 50);
    [self.view addSubview:self.detailsButton];
    [self.detailsButton autoCenterInSuperview];
    [self.detailsButton autoSetDimensionsToSize:size];
    
    size = CGSizeMake(280, 70);
    [self.view addSubview:self.titleLabel];
    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleLabel autoSetDimensionsToSize:size];
    [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.detailsButton withOffset:-40];
    
    [self.view addSubview:self.dismissButton];
    [self.dismissButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-15];
    [self.dismissButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.dismissButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.dismissButton autoSetDimension:ALDimensionHeight toSize:60];
    
    [UIView animateWithDuration:0.5f delay:2 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        self.dismissButton.alpha = 1;
    } completion:nil];
}

#pragma mark - Actions
- (void) openSettingsPressed:(UIButton*)sender {
    if ([self canOpenSettings]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Status bar states
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate {
    return ([[UIDevice currentDevice] orientation] != UIDeviceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
