//
//  SCCameraViewController.m
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCCameraViewController.h"
#import "SCCaptureManager.h"
#import "SCCaptureView.h"
#import "SCReviewController.h"
#import "SCImagePickerController.h"
#import "SCAssetsManager.h"
#import "SCCameraView.h"
#import "SCPageView.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCCameraViewController () <UIActionSheetDelegate, SCPhotoManagerDelegate>

@property (nonatomic, assign) BOOL recording;
@property (nonatomic, weak) SCCaptureManager *captureManager;
@property (nonatomic, strong) SCCameraView *cameraView;

@end

@implementation SCCameraViewController

- (SCCaptureManager*) captureManager {
    if (!_captureManager) {
        _captureManager = [SCCaptureManager sharedInstance];
        _captureManager.photoManager.delegate = self;
        _captureManager.videoManager.maximumStitchCount = 1;
    }
    return _captureManager;
}

- (SCCameraView*) cameraView {
    if (!_cameraView) {
        _cameraView = [[SCCameraView alloc] initWithFrame:self.view.frame captureManager:self.captureManager];
        
        _cameraView.recordButton.delegate = self;
        [_cameraView.chooseExistingButton addTarget:self action:@selector(chooseExistingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.aspectRatioButton addTarget:self action:@selector(aspectRatioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.flashModeButton addTarget:self action:@selector(flashModeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.toggleCameraButton addTarget:self action:@selector(cameraToggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _cameraView.progressBar.delegate = self;
    }
    return _cameraView;
}

- (SCCaptureType) currentCaptureType {
    return self.captureManager.captureType;
}

- (id) initWithCaptureType:(SCCaptureType)captureType {
    if (self = [super init]) {
        self.captureManager.captureType = captureType;
    }
    return self;
}

#pragma mark - View state
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.cameraView];
    [self.cameraView autoCenterInSuperview];
    [self.cameraView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.cameraView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    
    //set current index to match capture type
    switch (self.captureManager.captureType) {
        case SCCaptureTypeVideo: self.cameraView.pageView.index = 0; break;
        case SCCaptureTypePhoto: self.cameraView.pageView.index = 1; break;
        default: break;
    }
    
    __weak typeof(self) weakSelf = self;
    [RACObserve(self.cameraView.progressBar, timeElapsed) subscribeNext:^(NSNumber *n) {
        NSTimeInterval elapsed = n.floatValue;
        NSInteger mins = elapsed / 60;
        NSInteger secs = elapsed - mins;
        weakSelf.cameraView.timeLabel.text = secs <= 9 ? [NSString stringWithFormat:@"%d:0%d", mins, secs] : [NSString stringWithFormat:@"%d:%d", mins, secs];
        BOOL shouldHidePageView = (secs > 0 || mins > 0);
        weakSelf.cameraView.pageView.hidden = shouldHidePageView;
        weakSelf.cameraView.timeLabel.hidden = !shouldHidePageView;
    }];
    
    [[RACObserve(self.cameraView.pageView, index) skip:1] subscribeNext:^(NSNumber *n) {
        weakSelf.cameraView.shutterToolbar.backgroundColor = [UIColor clearColor];
        weakSelf.cameraView.shutterToolbar.hidden = NO;

        NSInteger index = n.integerValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            switch (index) {
                case 0:
                    weakSelf.captureManager.captureType = SCCaptureTypeVideo;
                    break;
                case 1:
                    weakSelf.captureManager.captureType = SCCaptureTypePhoto;
                    break;
                case 2:
                    weakSelf.captureManager.captureType = SCCaptureTypePhoto;
                    break;
                default:
                    break;
            }
        });
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(removeBlur) object:nil];
        [weakSelf performSelector:@selector(removeBlur) withObject:nil afterDelay:1.f];
    }] ;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired: 2];
    [self.view addGestureRecognizer:doubleTap];
    doubleTap.delegate = self;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired: 1];
    [self.view addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    singleTap.delegate = self;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    swipeGesture.delegate = self;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    swipeGesture.delegate = self;

    [self.captureManager.captureSession startRunning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self.cameraView.captureView addSessionIfNeeded:self.captureManager.captureSession];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraView.captureView removeSession];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // We /really/ need a delegate callback here instead...or, since RAC, a signal to bind to.
    //    if ([SCAssetsManager sharedInstance].image) {
    //        SCReviewController *vc = [[SCReviewController alloc] init];
    //        vc.image = [SCAssetsManager sharedInstance].image;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}

#pragma mark - Status bar states
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Actions

-(void)chooseExistingButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Taken", @"All Photos", nil];
    actionSheet.delegate = (id<UIActionSheetDelegate>)actionSheet;
    [[actionSheet rac_signalForSelector:@selector(actionSheet:didDismissWithButtonIndex:) fromProtocol:@protocol(UIActionSheetDelegate)] subscribeNext:^(RACTuple *t) {
        UIActionSheet *a = t.first;
        NSInteger index = [t.second integerValue];
        if (index != a.cancelButtonIndex) {
            if (index == 0) {
                [[[[SCAssetsManager sharedInstance] fetchLastPhoto] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
                    SCReviewController *vc = [[SCReviewController alloc] init];
                    vc.image = image;
                    [self.navigationController pushViewController:vc animated:YES];
                } error:^(NSError *error) {
                    NSLog(@"ERROR: %@", error);
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SCImagePickerController *picker = [SCImagePickerController new];
                    picker.completionBlock = ^(UIImage *image) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            SCReviewController *vc = [[SCReviewController alloc] init];
                            vc.image = image;
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                    };
                    [self presentViewController:picker animated:YES completion:nil];
                });
            }
        }
    }];
    [actionSheet showInView:self.view];
}


-(void)flashModeButtonPressed:(UIButton *)sender {
    NSError *error = nil;
    [self.captureManager.currentManager.currentCamera lockForConfiguration:&error];
    
    AVCaptureFlashMode mode = [self.cameraView cycleFlashMode];
    if ([self.captureManager.photoManager isFlashModeActive:mode]) {
        [self.captureManager.currentManager.currentCamera setFlashMode:mode];
    }

    [self.captureManager.currentManager.currentCamera unlockForConfiguration];
}

-(void)cameraToggleButtonPressed:(UIButton *)sender {
    [self switchCamera];
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
//    [self switchCamera];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)tapRecognizer {
    //focus here
}

- (void) handleSwipeLeftGesture:(UISwipeGestureRecognizer*) swipeGesture {
    self.cameraView.pageView.index++;
}

- (void) handleSwipeRightGesture:(UISwipeGestureRecognizer*)swipeGesture {
    self.cameraView.pageView.index--;
}

-(void)closeButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidFinish:)]) {
        [self.delegate cameraViewControllerDidFinish:self];
    }
}

-(void)aspectRatioButtonPressed:(id)sender {
    [self.cameraView cycleAspectRatio];
//    self.captureManager.photoManager.aspectRatioDefault = [self.captureManager.photoManager toggleAspectRatio];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.cameraView.recordButton)
        return NO;
    return YES;
}


#pragma mark - Camera toggle handling
-(void)switchCamera
{
    self.cameraView.shutterToolbar.backgroundColor = [UIColor clearColor];
    self.cameraView.shutterToolbar.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if (self.captureManager.photoManager.currentCamera == self.captureManager.photoManager.rearCamera) {
        if ([self.captureManager.photoManager hasAvailableCameraType:SCCameraTypeFrontFacing]) {
                [self.captureManager.photoManager setCameraType:SCCameraTypeFrontFacing];
            }
        } else {
            if ([self.captureManager.photoManager hasAvailableCameraType:SCCameraTypeRear]) {
                [self.captureManager.photoManager setCameraType:SCCameraTypeRear];
            }
        }
    });
    [self performSelector:@selector(removeBlur) withObject:nil afterDelay:1.f];
}

-(void)removeBlur {
    self.cameraView.shutterToolbar.backgroundColor = [UIColor blackColor];
    self.cameraView.shutterToolbar.hidden = YES;
}

#pragma mark - SCPhotoManager Delegate

-(void)imageCaptureCompleted
{
    self.cameraView.shutterToolbar.hidden = YES;
    if ([[SCCaptureManager sharedInstance] photoManager].image) {
        SCReviewController *vc = [[SCReviewController alloc] init];
        vc.image = [[SCCaptureManager sharedInstance] photoManager].image;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - SCProgressBarDelegate

- (void) progressBarDidStart:(SCProgressBar*)progressBar {
}

- (void) progressBarDidPause:(SCProgressBar*)progressBar {

}

- (void) progressBarDidStop:(SCProgressBar*)progressBar withTime:(NSTimeInterval)time {

}

#pragma mark - SCRecordButtonDelegate
- (void) recordButtonStartedHolding:(SCRecordButton *)button {
    [self.captureManager.videoManager startCapture];
    [self.cameraView animateHudHidden:YES completion:nil];
    [self.cameraView.progressBar start];
}

- (void) recordButtonStoppedHolding:(SCRecordButton *)button {
    [self.captureManager.videoManager startCapture];
    [self.cameraView animateHudHidden:NO completion:nil];
    [self.cameraView.progressBar pause];
}

- (void) recordButtonTapped:(SCRecordButton *)button {
    [self.captureManager.photoManager captureImage];
}

@end
