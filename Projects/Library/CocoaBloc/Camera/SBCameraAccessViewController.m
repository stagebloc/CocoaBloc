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
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SBCameraAccessViewController ()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIButton *detailsButton;

@end

@implementation SBCameraAccessViewController

- (UIButton*) titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.titleLabel.font = [UIFont fc_lightFontWithSize:24];
        _titleButton.titleLabel.numberOfLines = 0;
        _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        NSString *title = @"Camera permissions are required";
        [_titleButton setTitle:title forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(openSettingsPressed:) forControlEvents:UIControlEventTouchUpInside];
        _titleButton.enabled = [self canOpenSettings];
    }
    return _titleButton;
}

- (UIButton*) detailsButton {
    if ([self canOpenSettings])
        return nil;
    
    if (!_detailsButton) {
        _detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailsButton.titleLabel.font = [UIFont fc_fontWithSize:18];
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
        _dismissButton.titleLabel.font = [UIFont fc_fontWithSize:16];
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
    
    NSString *title = @"Camera permissions\nare required";
    if ([mediaType isEqualToString:AVMediaTypeAudio]) {
        title = @"Audio permissions\nare required";
    }
    if ([self canOpenSettings])
        title = [title stringByAppendingString:@"\n\nTap to update"];
    
    [self.titleButton setTitle:title forState:UIControlStateNormal];
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
    if (self.detailsButton) {
        [self.view addSubview:self.detailsButton];
        [self.detailsButton autoCenterInSuperview];
        [self.detailsButton autoSetDimensionsToSize:size];
    }
    
    size = CGSizeMake(280, [self canOpenSettings] ? 110 : 70);
    [self.view addSubview:self.titleButton];
    [self.titleButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-110];
    [self.titleButton autoSetDimensionsToSize:size];
    
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
