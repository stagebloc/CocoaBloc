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

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCCameraViewController () <UIActionSheetDelegate, SCPhotoManagerDelegate>
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *chooseExisting;
@property UIToolbar *toolbar;
@property BOOL toolBarExpanded;
@property (nonatomic, strong) UIButton *close;
@property (nonatomic, strong) UIButton *toggleAspectRatio;
@property (nonatomic, strong) UIButton *adjustFlashMode;
@property (nonatomic, strong) UIButton *toggleCamera;
@property (nonatomic, strong) UISwitch *toggleSwitch;
@property (nonatomic, strong) UILongPressGestureRecognizer *press;
@property (nonatomic, strong) UIView *topOverlay;
@property (nonatomic, strong) UIView *bottomOverlay;
@property (nonatomic, strong) UIToolbar *shutterView;

@property (nonatomic, assign) BOOL recording;
@property (nonatomic, strong) SCCaptureManager *captureManager;

@property (nonatomic, strong) SCProgressBar *progressBar;

@end

@implementation SCCameraViewController

- (SCProgressBar*) progressBar {
    if (!_progressBar) {
        _progressBar = [[SCProgressBar alloc] initWithMinValue:0 maxValue:10];
        _progressBar.delegate = self;
    }
    return _progressBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _toolBarExpanded = NO;

    self.view.backgroundColor = [UIColor blackColor];

    self.captureManager = [SCCaptureManager sharedInstance];
    self.captureManager.photoManager.delegate = self;
    ((SCVideoManager *)self.captureManager.videoManager).maximumStitchCount = 1;

    SCCaptureView *captureView = [[SCCaptureView alloc] initWithCaptureSession:self.captureManager.captureSession];
    [self.view addSubview:captureView];
    [captureView autoCenterInSuperview];
    [captureView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [captureView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    ((AVCaptureVideoPreviewLayer *)captureView.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;

    _shutterView = [[UIToolbar alloc] initWithFrame:self.view.bounds];
    _shutterView.backgroundColor = [UIColor blackColor];
    _shutterView.barStyle = UIBarStyleBlack;
    _shutterView.hidden = YES;
    [self.view addSubview:_shutterView];

    _topOverlay = [[UIView alloc] init];
    _topOverlay.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_topOverlay];

    [_topOverlay autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.f];
    [_topOverlay autoSetDimension:ALDimensionHeight toSize:44.f];
    [_topOverlay autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_topOverlay autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:0.0];

    _bottomOverlay = [[UIView alloc] init];
    _bottomOverlay.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomOverlay];

    [_bottomOverlay autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.f];
    [_bottomOverlay autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_bottomOverlay autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(self.view.bounds) - CGRectGetWidth(self.view.bounds) - 44.f];
    [_bottomOverlay autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:0.0];

    [self.view addSubview:self.progressBar];
    [self.progressBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.progressBar autoSetDimension:ALDimensionHeight toSize:5.0f];
    [self.progressBar autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.progressBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0];

    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), 0.0f)];
    _toolbar.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _toolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_toolbar];

    self.toggleAspectRatio = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toggleAspectRatio.frame = CGRectMake(CGRectGetWidth(_toolbar.bounds) -45.f, 15.f , 30.0, 30.0);
    //    [self.toggleAspectRatio setBackgroundImage:[UIImage imageNamed:@"toggle_ratio"] forState:UIControlStateNormal];
    [self.toggleAspectRatio setBackgroundColor:[UIColor greenColor]];
    self.toggleAspectRatio.layer.masksToBounds = YES;
    [self.toggleAspectRatio addTarget:self action:@selector(selectToggleAspectRatio:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:_toggleAspectRatio];

    _adjustFlashMode = [UIButton buttonWithType:UIButtonTypeCustom];
    _adjustFlashMode.frame = CGRectMake(CGRectGetMinX(_toolbar.bounds) + 15.f, 15.f, 30.0, 30.0);
    //    [_adjustFlashMode setBackgroundImage:[UIImage imageNamed:@"toggle_ratio"] forState:UIControlStateNormal];
    [_adjustFlashMode setBackgroundColor:[UIColor blueColor]];
    _adjustFlashMode.layer.masksToBounds = YES;
    [_adjustFlashMode addTarget:self action:@selector(selectAdjustFlashMode:) forControlEvents:UIControlEventTouchUpInside];
    _adjustFlashMode.tag = 0;
    [_toolbar addSubview:_adjustFlashMode];

    _toggleCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _toggleCamera.frame = CGRectMake(CGRectGetWidth(_toolbar.bounds)/2 - 15.f, 15.f, 30.0, 30.0);
    //    [self.toggleAspectRatio setBackgroundImage:[UIImage imageNamed:@"toggle_ratio"] forState:UIControlStateNormal];
    [_toggleCamera setBackgroundImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
    [_toggleCamera addTarget:self action:@selector(selectCameraToggle:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:_toggleCamera];

    _toggleSwitch = [[UISwitch alloc] init];
    [_toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_toggleSwitch];
    [_toggleSwitch autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-10.0f];
    [_toggleSwitch autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:(self.view.frame.size.width/2) - (_toggleSwitch.frame.size.width/2)];

    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.backgroundColor = [UIColor whiteColor];
    self.recordButton.layer.masksToBounds = YES;
    [self.recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
    [self.recordButton autoSetDimension:ALDimensionWidth toSize:64.f];
    [self.recordButton autoSetDimension:ALDimensionHeight toSize:64.f];
    [self.recordButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.recordButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-60.f];

    self.chooseExisting = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseExisting setBackgroundImage:[UIImage imageNamed:@"existing"] forState:UIControlStateNormal];
    self.chooseExisting.layer.masksToBounds = YES;
    [self.chooseExisting addTarget:self action:@selector(selectChooseExisting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseExisting];

    [self.chooseExisting autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.f];
    [self.chooseExisting autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-15.f];

    self.close = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.close setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    self.close.layer.masksToBounds = YES;
    [self.close addTarget:self action:@selector(selectClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.close];

    [self.close autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.f];
    [self.close autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:15.f];

    UIButton *expandControlPanel = [[UIButton alloc] init];
    [expandControlPanel setImage:[UIImage imageNamed:@"options"] forState:UIControlStateNormal];
    expandControlPanel.layer.masksToBounds = YES;
    [expandControlPanel addTarget:self action:@selector(selectExpandControlPanel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:expandControlPanel];

    [expandControlPanel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15.f];
    [expandControlPanel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-15.f];

    __weak typeof(self) weakSelf = self;
    RAC(self.topOverlay, hidden) = RACObserve(self, captureManager.photoManager.aspectRatioDefault).distinctUntilChanged;
    RAC(self.bottomOverlay, hidden) = RACObserve(self, captureManager.photoManager.aspectRatioDefault).distinctUntilChanged;
    RAC(self.recordButton, backgroundColor) = [RACObserve(self, recording) map:^UIColor *(NSNumber *recording) {
        return (recording.boolValue ? [UIColor redColor] : [UIColor whiteColor]);
    }];
    RAC(self, recording) =
    [RACSignal
     combineLatest:@[RACObserve(self.recordButton, highlighted), RACObserve(self.recordButton, selected)]
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.recordButton.layer.cornerRadius = CGRectGetHeight(self.recordButton.frame) / 2;
}

//holding camera button
- (void) shouldStartCapturing {
    [self.captureManager.videoManager startCapture];
}

//released camera button
- (void) shouldStopCapturing {
    [self.captureManager.videoManager stopCapture];
}

-(void)recordButtonTapped:(id)sender
{
    _shutterView.hidden = NO;
    [[[SCCaptureManager sharedInstance] photoManager] captureImage];
}

#pragma mark - Choose existing methods

-(void)selectChooseExisting:(id)sender
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

#pragma mark - Adjust settings

-(void)selectAdjustFlashMode:(UIButton *)sender
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

#pragma mark - Camera toggle handling

-(void)handleDoubleTap:(UITapGestureRecognizer *)tapRecognizer
{
    [self switchCamera];
}

-(void)selectCameraToggle:(UIButton *)sender
{
    [self switchCamera];
}

-(void)switchCamera
{
    _shutterView.backgroundColor = [UIColor clearColor];
    _shutterView.hidden = NO;
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

-(void)removeBlur
{
    _shutterView.backgroundColor = [UIColor blackColor];
    _shutterView.hidden = YES;
}


-(void)selectClose:(id)sender
{
    // Dismiss the view controller within the larger application
}

-(void)selectToggleAspectRatio:(id)sender
{
    self.captureManager.photoManager.aspectRatioDefault = [self.captureManager.photoManager toggleAspectRatio];
}

#pragma mark - SCPhotoManager Delegate

-(void)imageCaptureCompleted
{
    _shutterView.hidden = YES;
    if ([[SCCaptureManager sharedInstance] photoManager].image) {
        SCReviewController *vc = [[SCReviewController alloc] init];
        vc.image = [[SCCaptureManager sharedInstance] photoManager].image;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    // We /really/ need a delegate callback here instead...or, since RAC, a signal to bind to.
//    if ([SCAssetsManager sharedInstance].image) {
//        SCReviewController *vc = [[SCReviewController alloc] init];
//        vc.image = [SCAssetsManager sharedInstance].image;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

-(void)switchChanged:(id)sender
{
    if (_toggleSwitch.on) {
        [self.recordButton removeGestureRecognizer:_press];
        [self.captureManager setCaptureType:SCCaptureTypePhoto];
    } else {
        [self.recordButton addGestureRecognizer:_press];
        self.captureManager.captureType = SCCaptureTypeVideo;
    }
}

#pragma mark - Options control panel

-(void)selectExpandControlPanel:(UIButton *)sender
{
    if (_toolBarExpanded) {
        [self animateDown];
    } else {
        [self animateUp];
    }
    _toolBarExpanded = !_toolBarExpanded;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)tapRecognizer
{
    [self animateDown];
    _toolBarExpanded = NO;
}

-(void)animateUp
{
    _toggleCamera.alpha = 0.0f;
    _toggleAspectRatio.alpha = 0.0f;
    _adjustFlashMode.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{_toggleCamera.alpha = 1.0;}];
    [UIView animateWithDuration:0.5 animations:^{_toggleAspectRatio.alpha = 1.0;}];
    [UIView animateWithDuration:0.5 animations:^{_adjustFlashMode.alpha = 1.0;}];

    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGFloat yOffset = self.recordButton.frame.origin.y - 80.f;
                         CGFloat height = CGRectGetMaxY(self.view.bounds) - yOffset;
                         _toolbar.frame = CGRectMake(self.view.frame.origin.x, yOffset, self.view.frame.size.width, height);                 }
                     completion:^(BOOL finished){
                         if (finished) {

                         }
                     }];
}

-(void)animateDown
{
    _toggleCamera.alpha = 1.0f;
    _toggleAspectRatio.alpha = 1.0f;
    _adjustFlashMode.alpha = 1.0f;
    [UIView animateWithDuration:0.5 animations:^{_toggleCamera.alpha = 0.0;}];
    [UIView animateWithDuration:0.5 animations:^{_toggleAspectRatio.alpha = 0.0;}];
    [UIView animateWithDuration:0.5 animations:^{_adjustFlashMode.alpha = 0.0;}];

    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _toolbar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, 0.0f);
                }
                     completion:^(BOOL finished){
                         if (finished) {

                         }
                     }];
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
