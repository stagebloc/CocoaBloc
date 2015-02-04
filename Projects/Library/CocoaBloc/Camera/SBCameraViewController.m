//
//  SBCameraViewController.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/1/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBCameraViewController.h"
#import "SBReviewController.h"
#import "UIDevice+Orientation.h"

@interface SBCameraViewController ()

@end

@implementation SBCameraViewController

- (UIViewController*)currentController {
    return [self.viewControllers lastObject];
}

- (void) setCaptureDelegate:(id<SBCaptureViewControllerDelegate>)captureDelegate {
    SBCaptureViewController *controller = [self.viewControllers firstObject];
    controller.delegate = captureDelegate;
}

- (id<SBCaptureViewControllerDelegate>)captureDelegate {
    SBCaptureViewController *controller = [self.viewControllers firstObject];
    return controller.delegate;
}

- (instancetype)init {
    return [self initWithReviewOptions:SBReviewViewOptionsDoNotShow];
}

- (instancetype)initWithReviewOptions:(SBReviewViewOptions)options {
    return [self initWithReviewOptions:options initialCaptureType:SBCaptureTypeVideo];
}

- (instancetype)initWithReviewOptions:(SBReviewViewOptions)options initialCaptureType:(SBCaptureType)captureType {
    return [self initWithReviewOptions:options initialCaptureType:captureType allowedCaptureTypes:SBCaptureTypePhoto | SBCaptureTypeVideo];
}

- (instancetype)initWithReviewOptions:(SBReviewViewOptions)options initialCaptureType:(SBCaptureType)captureType allowedCaptureTypes:(SBCaptureType)allowedCaptureTypes {
    if (self = [super init]) {
        SBCaptureViewController *controller = [[SBCaptureViewController alloc] initWithInitialCaptureType:captureType allowedCaptureTypes:allowedCaptureTypes];
        controller.reviewOptions = options;
        [self setViewControllers:@[controller]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate {
    return [self.currentController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.currentController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self.currentController isKindOfClass:[SBCaptureViewController class]])
        return [self.currentController preferredInterfaceOrientationForPresentation];
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] interfaceOrientation];
    return (NSInteger)orientation == -1 ? UIInterfaceOrientationPortrait : orientation;
}

@end
