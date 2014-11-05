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

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCCameraViewController () <UIActionSheetDelegate, SCPhotoManagerDelegate>

@property (nonatomic, assign) BOOL toolBarExpanded;
@property (nonatomic, assign) BOOL recording;
@property (nonatomic, strong) SCCaptureManager *captureManager;
@property (nonatomic, strong) SCCameraView *cameraView;

@end

@implementation SCCameraViewController

- (SCCameraView*) cameraView {
    if (!_cameraView) {
        _cameraView = [[SCCameraView alloc] initWithFrame:self.view.frame captureManager:self.captureManager];
        
        [_cameraView.recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.chooseExistingButton addTarget:self action:@selector(chooseExistingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [_cameraView.toggleAspectRatioButton addTarget:self action:@selector(toggleAspectRatioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.adjustFlashModeButton addTarget:self action:@selector(adjustFlashModeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.toggleCameraButton addTarget:self action:@selector(cameraToggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _cameraView.progressBar.delegate = self;
    }
    return _cameraView;
}

#pragma mark - View state
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.toolBarExpanded = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.captureManager = [SCCaptureManager sharedInstance];
    self.captureManager.photoManager.delegate = self;
    ((SCVideoManager *)self.captureManager.videoManager).maximumStitchCount = 1;
    
    [self.view addSubview:self.cameraView];
    [self.cameraView autoCenterInSuperview];
    [self.cameraView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.cameraView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    
    __weak typeof(self) weakSelf = self;
    RAC(self.cameraView.topOverlayView, hidden) = RACObserve(self, captureManager.photoManager.aspectRatioDefault).distinctUntilChanged;
    RAC(self.cameraView.bottomOverlayView, hidden) = RACObserve(self, captureManager.photoManager.aspectRatioDefault).distinctUntilChanged;
    RAC(self.cameraView.recordButton, backgroundColor) = [RACObserve(self, recording) map:^UIColor *(NSNumber *recording) {
        return (recording.boolValue ? [UIColor redColor] : [UIColor whiteColor]);
    }];
    RAC(self, recording) =
    [RACSignal
     combineLatest:@[RACObserve(self.cameraView.recordButton, highlighted), RACObserve(self.cameraView.recordButton, selected)]
     reduce:^ id (NSNumber *highlighted, NSNumber *selected) {
         typeof(weakSelf) strongSelf = self;
         
         BOOL isButtonSelected = highlighted.boolValue | selected.boolValue;
         BOOL isCurrentlyRecording = strongSelf.recording;
         
         //TOUCH BEGAN
         if (isButtonSelected && !isCurrentlyRecording) {
             [strongSelf shouldStartCapturing];
         }
         
         //TOUCH ENDED
         else if (!isButtonSelected && isCurrentlyRecording) {
             [strongSelf shouldStopCapturing];
         }
         
         return @(isButtonSelected);
     }];


    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired: 2];
    [self.view addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired: 1];
    [self.view addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];

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
//holding camera button
- (void) shouldStartCapturing {
    [self.captureManager.videoManager startCapture];
}

//released camera button
- (void) shouldStopCapturing {
    [self.captureManager.videoManager stopCapture];
}

-(void)recordButtonPressed:(id)sender
{
    self.cameraView.shutterToolbar.hidden = NO;
    [[[SCCaptureManager sharedInstance] photoManager] captureImage];
}

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


-(void)adjustFlashModeButtonPressed:(UIButton *)sender
{
    sender.tag ++;
    if (sender.tag > 2) {
        sender.tag = 0;
    }
    
    NSError *error = nil;
    [self.captureManager.currentManager.currentCamera lockForConfiguration:&error];
    
    switch (sender.tag) {
        case AVCaptureFlashModeOff:
            if  ([self.captureManager.photoManager isFlashModeAvailable:AVCaptureFlashModeOff]) {
                [self.captureManager.currentManager.currentCamera setFlashMode:AVCaptureFlashModeOff];
                sender.alpha = 1.f;
                //              [sender setBackgroundImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
            }
            break;
        case AVCaptureFlashModeOn:
            if ([self.captureManager.photoManager isFlashModeAvailable:AVCaptureFlashModeOn]) {
                [self.captureManager.currentManager.currentCamera setFlashMode:AVCaptureFlashModeOn];
                //              [sender setBackgroundImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
                sender.alpha = .75f;
            } else {
                //              [sender setBackgroundImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
                sender.tag = 0;
                sender.alpha = 1.f;
            }
            break;
        case AVCaptureFlashModeAuto:
            if ([self.captureManager.photoManager isFlashModeAvailable:AVCaptureFlashModeAuto]) {
                [self.captureManager.currentManager.currentCamera setFlashMode:AVCaptureFlashModeAuto];
                //              [sender setBackgroundImage:[UIImage imageNamed:@"flash_auto"] forState:UIControlStateNormal];
                sender.alpha = .5f;
            } else {
                //              [_flashMode setBackgroundImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
                sender.tag = 0;
                sender.alpha = 1.f;
            }
            break;
        default:
            NSLog(@"Error");
            break;
    }
    [self.captureManager.currentManager.currentCamera unlockForConfiguration];
}

-(void)switchChanged:(UISwitch*)sender {
    if (sender.on) {
        self.captureManager.captureType = SCCaptureTypePhoto;
    } else {
        self.captureManager.captureType = SCCaptureTypeVideo;
    }
}

-(void)cameraToggleButtonPressed:(UIButton *)sender {
    [self switchCamera];
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
    [self switchCamera];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)tapRecognizer {
    if ([self.cameraView isHudHidden]) {
        [self.cameraView animateHudHidden:NO completion:nil];
    } else {
        [self.cameraView animateHudHidden:YES completion:nil];
    }
}

-(void)closeButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidFinish:)]) {
        [self.delegate cameraViewControllerDidFinish:self];
    }
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

-(void)toggleAspectRatioButtonPressed:(id)sender {
    self.captureManager.photoManager.aspectRatioDefault = [self.captureManager.photoManager toggleAspectRatio];
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
    NSLog(@"didstart");
}

- (void) progressBarDidPause:(SCProgressBar*)progressBar {
    NSLog(@"didpause");
}

- (void) progressBarDidStop:(SCProgressBar*)progressBar withTime:(NSTimeInterval)time {
    NSLog(@"didstop");
}

@end
