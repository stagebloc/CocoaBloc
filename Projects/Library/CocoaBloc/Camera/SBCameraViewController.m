//
//  SBCameraViewController.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/1/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBCameraViewController.h"

@interface SBCameraViewController ()

@end

@implementation SBCameraViewController

- (void) setCaptureDelegate:(id<SBCaptureViewControllerDelegate>)captureDelegate {
    SBCaptureViewController *controller = [self.viewControllers firstObject];
    controller.delegate = captureDelegate;
}

- (id<SBCaptureViewControllerDelegate>) captureDelegate {
    SBCaptureViewController *controller = [self.viewControllers firstObject];
    return controller.delegate;
}

- (instancetype) init {
    return [self initWithCaptureType:SBCaptureTypeVideo];
}

- (instancetype) initWithCaptureType:(SBCaptureType)captureType {
    if (self = [super init]) {
        SBCaptureViewController *controller = [[SBCaptureViewController alloc] initWithCaptureType:captureType];
        [self setViewControllers:@[controller]];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
}

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
