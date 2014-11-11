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
#import "SCProgressBar.h"
#import "SCRecordButton.h"
#import "SCAlbumViewController.h"
#import "UIColor+FanClub.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCCameraViewController () <UIActionSheetDelegate, SCPhotoManagerDelegate, SCProgressBarDelegate, SCRecordButtonDelegate>

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
        _cameraView.recordButton.holdingInterval = 0.2f;
        
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
    NSInteger page = self.captureManager.captureType == SCCaptureTypeVideo ? 0 : 1;
    [self.cameraView.pageView setIndex:page duration:0];
    
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
    
    [RACObserve(self.cameraView.pageView, index) subscribeNext:^(NSNumber *n) {
        NSInteger index = n.integerValue;

        weakSelf.cameraView.stateToolbar.backgroundColor = [UIColor clearColor];
        weakSelf.cameraView.stateToolbar.hidden = NO;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self switchedToPage:index];
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

#pragma mark - Camera state handling
- (void) switchedToPage:(NSInteger)page {
    AVCaptureFlashMode prevFlashMode = self.captureManager.currentManager.flashMode;
    switch (page) {
        case 0:
            self.captureManager.captureType = SCCaptureTypeVideo;
            self.cameraView.recordButton.allowHold = YES;
            self.cameraView.recordButton.borderColor = [UIColor redColor].CGColor;
            break;
        case 1:
            self.captureManager.captureType = SCCaptureTypePhoto;
            self.captureManager.photoManager.aspectRatio = SCCameraAspectRatio4_3;
            self.cameraView.recordButton.allowHold = NO;
            self.cameraView.recordButton.borderColor = [UIColor fc_stageblocBlueColor].CGColor;
            break;
        case 2:
            self.captureManager.captureType = SCCaptureTypePhoto;
            self.captureManager.photoManager.aspectRatio = SCCameraAspectRatio1_1;
            self.cameraView.recordButton.allowHold = NO;
            self.cameraView.recordButton.borderColor = [UIColor fc_stageblocBlueColor].CGColor;
            break;
        default:
            break;
    }
    [self updateFlashMode:prevFlashMode]; //update new flash mode
}

- (void) updateFlashMode:(AVCaptureFlashMode)mode {
    NSError *error = nil;
    [self.captureManager.currentManager.currentCamera lockForConfiguration:&error];
    
    if ([self.captureManager.currentManager isFlashModeAvailable:mode]) {
        self.captureManager.currentManager.flashMode = mode;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cameraView.flashMode = self.captureManager.currentManager.flashMode;
    });
    
    [self.captureManager.currentManager.currentCamera unlockForConfiguration];
}

-(void)switchCamera {
    self.cameraView.stateToolbar.backgroundColor = [UIColor clearColor];
    self.cameraView.stateToolbar.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVCaptureFlashMode prevFlashMode = self.captureManager.currentManager.flashMode;
        if (self.captureManager.currentManager.currentCamera == self.captureManager.photoManager.rearCamera) {
            if ([self.captureManager.currentManager hasAvailableCameraType:SCCameraTypeFrontFacing]) {
                self.captureManager.currentManager.cameraType = SCCameraTypeFrontFacing;
            }
        } else {
            if ([self.captureManager.currentManager hasAvailableCameraType:SCCameraTypeRear]) {
                self.captureManager.currentManager.cameraType = SCCameraTypeRear;
            }
        }
        [self updateFlashMode:prevFlashMode];
    });
    [self performSelector:@selector(removeBlur) withObject:nil afterDelay:1.f];
}

-(void)removeBlur {
    self.cameraView.stateToolbar.backgroundColor = [UIColor blackColor];
    self.cameraView.stateToolbar.hidden = YES;
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
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Taken", @"All Photos", nil];
    actionSheet.delegate = (id<UIActionSheetDelegate>)actionSheet;
    [[actionSheet rac_signalForSelector:@selector(actionSheet:didDismissWithButtonIndex:) fromProtocol:@protocol(UIActionSheetDelegate)] subscribeNext:^(RACTuple *t) {
        UIActionSheet *a = t.first;
        NSInteger index = [t.second integerValue];
        if (index != a.cancelButtonIndex) {
            if (index == 0) {
                [[[[SCAssetsManager sharedInstance] fetchLastPhoto] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
                    SCReviewController *vc = [[SCReviewController alloc] initWithImage:image];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } error:^(NSError *error) {
                    NSLog(@"ERROR: %@", error);
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SCImagePickerController *picker = [[SCImagePickerController alloc] init];
                    picker.completionBlock = ^(UIImage *image, NSDictionary *info) {
                        if (image) {
                            SCReviewController *vc = [[SCReviewController alloc] initWithImage:image];
                            [weakSelf.navigationController pushViewController:vc animated:NO];
                        }
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    };
                    [weakSelf presentViewController:picker animated:YES completion:nil];
                });
            }
        }
    }];
    [actionSheet showInView:self.view];
}


-(void)flashModeButtonPressed:(UIButton *)sender {
    AVCaptureFlashMode mode = [self.cameraView cycleFlashMode];
    [self updateFlashMode:mode];
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
    if (self.cameraView.progressBar.timeElapsed > 0) {
        return;
    }

    if (self.cameraView.pageView.index + 1 <= self.cameraView.pageView.labels.count-1)
        self.cameraView.pageView.index++;
}

- (void) handleSwipeRightGesture:(UISwipeGestureRecognizer*)swipeGesture {
    if (self.cameraView.progressBar.timeElapsed > 0) {
        return;
    }

    if (self.cameraView.pageView.index - 1 >= 0)
        self.cameraView.pageView.index--;
}

-(void)closeButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidFinish:)]) {
        [self.delegate cameraViewControllerDidFinish:self];
    }
}

-(void)aspectRatioButtonPressed:(id)sender {
    [self.cameraView cycleAspectRatio];
//    self.captureManager.photoManager.aspectRatioDefault = !self.captureManager.photoManager.aspectRatioDefault;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.cameraView.recordButton)
        return NO;
    return YES;
}


#pragma mark - SCPhotoManager Delegate

-(void)photoManager:(SCPhotoManager*)manager capturedImage:(UIImage*)image {
    self.cameraView.stateToolbar.hidden = YES;
    if (image) {
        SCReviewController *vc = [[SCReviewController alloc] initWithImage:image];
        [self.navigationController pushViewController:vc animated:YES];
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
    //only accept video mode for this logic
    if (self.captureManager.captureType != SCCaptureTypeVideo)
        return;
    
    NSLog(@"Started recording");
    [self.captureManager.videoManager startCapture];
    [self.cameraView animateHudHidden:YES completion:nil];
    [self.cameraView.progressBar start];
}

- (void) recordButtonStoppedHolding:(SCRecordButton *)button {
    //snap picture b/c we are in photo mode
    if (self.captureManager.captureType == SCCaptureTypePhoto) {
        NSLog(@"Captured image");
        [self.captureManager.photoManager captureImage];
    }
    
    //pause video
    else {
        NSLog(@"Stopped recording");
        [self.captureManager.videoManager stopCapture];
        [self.cameraView animateHudHidden:NO completion:nil];
        [self.cameraView.progressBar pause];
    }
}

- (void) recordButtonTapped:(SCRecordButton *)button {
    //only accept photo mode for this logic
    if (self.captureManager.captureType != SCCaptureTypePhoto)
        return;
    
    [self.cameraView animateShutterWithDuration:.1 completion:nil];
    [self.captureManager.photoManager captureImage];
}

@end
