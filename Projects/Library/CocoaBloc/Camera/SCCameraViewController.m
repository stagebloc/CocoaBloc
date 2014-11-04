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
@property (nonatomic, strong) UIButton *chooseExistingButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UISwitch *toggleSwitch;
@property (nonatomic, strong) UIButton *optionsButton;

//toolbar
@property UIToolbar *toolbar;
@property BOOL toolBarExpanded;
@property (nonatomic, strong) UIButton *toggleAspectRatioButton;
@property (nonatomic, strong) UIButton *adjustFlashModeButton;
@property (nonatomic, strong) UIButton *toggleCameraButton;
//

@property (nonatomic, strong) UIView *topOverlayView;
@property (nonatomic, strong) UIView *bottomOverlayView;

@property (nonatomic, strong) UIToolbar *shutterToolbar;

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


- (UIButton*) recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.backgroundColor = [UIColor whiteColor];
        _recordButton.layer.masksToBounds = YES;
        [_recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

- (UIButton*) chooseExistingButton {
    if (!_chooseExistingButton) {
        _chooseExistingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseExistingButton setImage:[UIImage imageNamed:@"existing"] forState:UIControlStateNormal];
        _chooseExistingButton.layer.masksToBounds = YES;
        [_chooseExistingButton addTarget:self action:@selector(chooseExistingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _chooseExistingButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _chooseExistingButton;
}

- (UIButton*) closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.imageView.contentMode = UIViewContentModeCenter;
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.layer.masksToBounds = YES;
        [_closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UISwitch*) toggleSwitch {
    if (!_toggleSwitch) {
        _toggleSwitch = [[UISwitch alloc] init];
        [_toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _toggleSwitch;
}

- (UIView*) topOverlayView {
    if (!_topOverlayView) {
        _topOverlayView = [[UIView alloc] init];
        _topOverlayView.backgroundColor = [UIColor blackColor];
    }
    return _topOverlayView;
}

- (UIView*) bottomOverlayView {
    if (!_bottomOverlayView) {
        _bottomOverlayView = [[UIView alloc] init];
        _bottomOverlayView.backgroundColor = [UIColor blackColor];
    }
    return _bottomOverlayView;
}

- (UIToolbar*) shutterToolbar {
    if (!_shutterToolbar) {
        _shutterToolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
        _shutterToolbar.backgroundColor = [UIColor blackColor];
        _shutterToolbar.barStyle = UIBarStyleBlack;
        _shutterToolbar.hidden = YES;
    }
    return _shutterToolbar;
}

- (UIButton*) optionsButton {
    if (!_optionsButton) {
        _optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_optionsButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        _optionsButton.layer.masksToBounds = YES;
        [_optionsButton addTarget:self action:@selector(expandControlButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _optionsButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _optionsButton;
}

#pragma mark - Toolbar views
- (UIToolbar*) toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), 0.0f)];
        _toolbar.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _toolbar.barStyle = UIBarStyleBlackOpaque;
    }
    return _toolbar;
}

- (UIButton*) toggleAspectRatioButton {
    if (!_toggleAspectRatioButton) {
        _toggleAspectRatioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleAspectRatioButton.frame = CGRectMake(CGRectGetWidth(_toolbar.bounds) -45.f, 15.f , 30.0, 30.0);
        //    [self.toggleAspectRatio setBackgroundImage:[UIImage imageNamed:@"toggle_ratio"] forState:UIControlStateNormal];
        [_toggleAspectRatioButton setBackgroundColor:[UIColor greenColor]];
        _toggleAspectRatioButton.layer.masksToBounds = YES;
        [_toggleAspectRatioButton addTarget:self action:@selector(toggleAspectRatioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleAspectRatioButton;
}

- (UIButton*) adjustFlashModeButton {
    if (!_adjustFlashModeButton) {
        _adjustFlashModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _adjustFlashModeButton.frame = CGRectMake(CGRectGetMinX(_toolbar.bounds) + 15.f, 15.f, 30.0, 30.0);
        //    [_adjustFlashMode setBackgroundImage:[UIImage imageNamed:@"toggle_ratio"] forState:UIControlStateNormal];
        [_adjustFlashModeButton setBackgroundColor:[UIColor blueColor]];
        _adjustFlashModeButton.layer.masksToBounds = YES;
        [_adjustFlashModeButton addTarget:self action:@selector(adjustFlashModeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _adjustFlashModeButton.tag = 0;
    }
    return _adjustFlashModeButton;
}

- (UIButton*) toggleCameraButton {
    if (!_toggleCameraButton) {
        _toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleCameraButton.frame = CGRectMake(CGRectGetWidth(_toolbar.bounds)/2 - 15.f, 15.f, 30.0, 30.0);
        //    [self.toggleAspectRatio setBackgroundImage:[UIImage imageNamed:@"toggle_ratio"] forState:UIControlStateNormal];
        [_toggleCameraButton setBackgroundImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
        [_toggleCameraButton addTarget:self action:@selector(cameraToggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleCameraButton;
}

#pragma mark - View state
- (void) initializeViews {
    //add capture view
    SCCaptureView *captureView = [[SCCaptureView alloc] initWithCaptureSession:self.captureManager.captureSession];
    [self.view addSubview:captureView];
    [captureView autoCenterInSuperview];
    [captureView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [captureView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    ((AVCaptureVideoPreviewLayer *)captureView.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    CGFloat buttonWH = 30;
    
    //shutter toolbar
    [self.view addSubview:self.shutterToolbar];
    
    //top overlay view
    [self.view addSubview:self.topOverlayView];
    [self.topOverlayView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.f];
    [self.topOverlayView autoSetDimension:ALDimensionHeight toSize:44.f];
    [self.topOverlayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.topOverlayView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:0.0];
    
    //bottom overlay view
    [self.view addSubview:self.bottomOverlayView];
    [self.bottomOverlayView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.f];
    [self.bottomOverlayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.bottomOverlayView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(self.view.bounds) - CGRectGetWidth(self.view.bounds) - 44.f];
    [self.bottomOverlayView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:0.0];
    
    //progress bar
    [self.view addSubview:self.progressBar];
    [self.progressBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.progressBar autoSetDimension:ALDimensionHeight toSize:5.0f];
    [self.progressBar autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.progressBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0];
    
    //tool bar
    [self.view addSubview:self.toolbar];
    [self.toolbar addSubview:self.toggleAspectRatioButton];
    [self.toolbar addSubview:self.adjustFlashModeButton];
    [self.toolbar addSubview:self.toggleCameraButton];
    
    //toggle switch
    [self.view addSubview:self.toggleSwitch];
    [self.toggleSwitch autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-10.0f];
    [self.toggleSwitch autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:(self.view.frame.size.width/2) - (self.toggleSwitch.frame.size.width/2)];
    
    //record button
    [self.view addSubview:self.recordButton];
    [self.recordButton autoSetDimension:ALDimensionWidth toSize:64.f];
    [self.recordButton autoSetDimension:ALDimensionHeight toSize:64.f];
    [self.recordButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.recordButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-60.f];
    
    //choose existing button
    [self.view addSubview:self.chooseExistingButton];
    [self.chooseExistingButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.f];
    [self.chooseExistingButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-15.f];
    [self.chooseExistingButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.chooseExistingButton autoSetDimension:ALDimensionWidth toSize:buttonWH];

    //close button
    [self.view addSubview:self.closeButton];
    [self.closeButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.closeButton autoSetDimension:ALDimensionWidth toSize:buttonWH];
    [self.closeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.f];
    [self.closeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:15.f];
    
    [self.view addSubview:self.optionsButton];
    [self.optionsButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.optionsButton autoSetDimension:ALDimensionWidth toSize:buttonWH];
    [self.optionsButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15.f];
    [self.optionsButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-15.f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.toolBarExpanded = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.captureManager = [SCCaptureManager sharedInstance];
    self.captureManager.photoManager.delegate = self;
    ((SCVideoManager *)self.captureManager.videoManager).maximumStitchCount = 1;
    
    [self initializeViews];

    __weak typeof(self) weakSelf = self;
    RAC(self.topOverlayView, hidden) = RACObserve(self, captureManager.photoManager.aspectRatioDefault).distinctUntilChanged;
    RAC(self.bottomOverlayView, hidden) = RACObserve(self, captureManager.photoManager.aspectRatioDefault).distinctUntilChanged;
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.recordButton.layer.cornerRadius = CGRectGetHeight(self.recordButton.frame) / 2;
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
    _shutterToolbar.hidden = NO;
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

-(void)switchChanged:(id)sender {
    if (_toggleSwitch.on) {
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
    [self animateDown];
    _toolBarExpanded = NO;
}

-(void)closeButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidFinish:)]) {
        [self.delegate cameraViewControllerDidFinish:self];
    }
}


-(void)expandControlButtonPressed:(UIButton *)sender {
    if (_toolBarExpanded) {
        [self animateDown];
    } else {
        [self animateUp];
    }
    _toolBarExpanded = !_toolBarExpanded;
}

#pragma mark - Camera toggle handling
-(void)switchCamera
{
    _shutterToolbar.backgroundColor = [UIColor clearColor];
    _shutterToolbar.hidden = NO;
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
    _shutterToolbar.backgroundColor = [UIColor blackColor];
    _shutterToolbar.hidden = YES;
}

-(void)toggleAspectRatioButtonPressed:(id)sender {
    self.captureManager.photoManager.aspectRatioDefault = [self.captureManager.photoManager toggleAspectRatio];
}

#pragma mark - SCPhotoManager Delegate

-(void)imageCaptureCompleted
{
    _shutterToolbar.hidden = YES;
    if ([[SCCaptureManager sharedInstance] photoManager].image) {
        SCReviewController *vc = [[SCReviewController alloc] init];
        vc.image = [[SCCaptureManager sharedInstance] photoManager].image;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - Options control panel

-(void)animateUp
{
    _toggleCameraButton.alpha = 0.0f;
    _toggleAspectRatioButton.alpha = 0.0f;
    _adjustFlashModeButton.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{_toggleCameraButton.alpha = 1.0;}];
    [UIView animateWithDuration:0.5 animations:^{_toggleAspectRatioButton.alpha = 1.0;}];
    [UIView animateWithDuration:0.5 animations:^{_adjustFlashModeButton.alpha = 1.0;}];

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
    _toggleCameraButton.alpha = 1.0f;
    _toggleAspectRatioButton.alpha = 1.0f;
    _adjustFlashModeButton.alpha = 1.0f;
    [UIView animateWithDuration:0.5 animations:^{_toggleCameraButton.alpha = 0.0;}];
    [UIView animateWithDuration:0.5 animations:^{_toggleAspectRatioButton.alpha = 0.0;}];
    [UIView animateWithDuration:0.5 animations:^{_adjustFlashModeButton.alpha = 0.0;}];

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
