//
//  SCCameraViewController.m
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBCaptureViewController.h"
#import "SBCaptureManager.h"
#import "SBCaptureView.h"
#import "SBImagePickerController.h"
#import "SBAssetsManager.h"
#import "SBCameraView.h"
#import "SBPageView.h"
#import "SBProgressBar.h"
#import "SBRecordButton.h"
#import "UIColor+CocoaBloc.h"
#import "SBVideoManager.h"
#import "SBPhotoManager.h"
#import "SBOverlayView.h"
#import "SBAsset.h"
#import "AVCaptureDevice+RAC.h"
#import "SBCameraAccessViewController.h"
#import "SBToolBarAnimator.h"
#import "SBPushAnimator.h"
#import "UIDevice+CocoaBloc.h"
#import "NSURL+Camera.h"
#import "UIApplication+Extension.h"
#import "UIDevice+Orientation.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import <AVFoundation/AVFoundation.h>

#import "PHPhotoLibrary+RAC.h"
#import "ALAssetsLibrary+RAC.h"

@interface SBCaptureViewController () <UIActionSheetDelegate, SCRecordButtonDelegate, SBReviewControllerDelegate>

@property (nonatomic, assign) BOOL recording;
@property (nonatomic) SBCaptureManager *captureManager;
@property (nonatomic) SBCameraView *cameraView;

@property (nonatomic) SBAssetsManager *assetManager;

@property (nonatomic) SBOverlayView *overlayHud;

@property (nonatomic) SBToolBarAnimator *animator;
@property (nonatomic) SBPushAnimator *navAnimator;

@property (nonatomic) SBCameraAccessViewController *accessController;

@end

@implementation SBCaptureViewController

- (SBToolBarAnimator*) animator {
    if (!_animator)
        _animator = [[SBToolBarAnimator alloc] init];
    return _animator;
}
- (SBPushAnimator*) navAnimator {
    if (!_navAnimator)
        _navAnimator = [[SBPushAnimator alloc] init];
    return _navAnimator;
}

- (SBAssetsManager*) assetManager {
    if (!_assetManager)
        _assetManager = [[SBAssetsManager alloc] init];
    return _assetManager;
}

- (SBCaptureManager*) captureManager {
    if (!_captureManager)
        _captureManager = [[SBCaptureManager alloc] init];
    return _captureManager;
}

- (SBCameraView*) cameraView {
    if (!_cameraView) {
        _cameraView = [[SBCameraView alloc] initWithFrame:self.view.frame captureManager:self.captureManager];
        
        _cameraView.recordButton.delegate = self;
        _cameraView.recordButton.holdingInterval = 0.2f;
        
        [_cameraView.chooseExistingButton addTarget:self action:@selector(chooseExistingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.flashModeButton addTarget:self action:@selector(flashModeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.toggleCameraButton addTarget:self action:@selector(cameraToggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.toggleRatioButton addTarget:self action:@selector(ratioToggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraView;
}

- (SBCameraAccessViewController*) accessController {
    if (!_accessController) {
        _accessController = [[SBCameraAccessViewController alloc] initWithMediaTypeDenied:AVMediaTypeAudio];
        [_accessController.dismissButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _accessController.view.backgroundColor = [UIColor clearColor];
        _accessController.view.alpha = 0;
    }
    return _accessController;
}

- (instancetype)init {
    return [self initWithInitialCaptureType:SBCaptureTypeVideo];
}

- (instancetype)initWithInitialCaptureType:(SBCaptureType)captureType {
    return [self initWithInitialCaptureType:captureType allowedCaptureTypes:SBCaptureTypePhoto | SBCaptureTypeVideo];
}

- (instancetype)initWithInitialCaptureType:(SBCaptureType)captureType allowedCaptureTypes:(SBCaptureType)allowedCaptureTypes {
    if (self = [super init]) {

        BOOL allowsPhoto = (allowedCaptureTypes & SBCaptureTypePhoto) != 0;
        BOOL allowsVideo = (allowedCaptureTypes & SBCaptureTypeVideo) != 0;
        
        //photo only - force capture type = photo
        if (allowsPhoto && !allowsVideo) {
            self.captureManager.captureType = SBCaptureTypePhoto;
        }
        
        //video only - force capture type = video
        else if (!allowsPhoto && allowsVideo) {
            self.captureManager.captureType = SBCaptureTypeVideo;
        }
        
        else {
            self.captureManager.captureType = captureType;
            
            //just in case we don't know that the hell the user put for allowed capture types,
            //just default to both video and photo
            allowedCaptureTypes = SBCaptureTypePhoto | SBCaptureTypeVideo;
        }
        
        _allowedCaptureTypes = allowedCaptureTypes;
    }
    return self;
}

#pragma mark - View state
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.delegate = self;

    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.cameraView];
    [self.cameraView autoCenterInSuperview];
    [self.cameraView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.cameraView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    
    BOOL allowsPhoto = (self.allowedCaptureTypes & SBCaptureTypePhoto) != 0;
    BOOL allowsVideo = (self.allowedCaptureTypes & SBCaptureTypeVideo) != 0;
    NSArray *pageViewLabels = self.cameraView.pageView.labels;
    if (allowsPhoto && !allowsVideo) {
        ((UILabel *)pageViewLabels[0]).hidden = YES;
    } else if (!allowsPhoto && allowsVideo) {
        ((UILabel *)pageViewLabels[1]).hidden = YES;
        ((UILabel *)pageViewLabels[2]).hidden = YES;
    }
    
    
    [self addChildViewController:self.accessController];
    [self.cameraView addSubview:self.accessController.view];
    
    //set current index to match capture type
    NSInteger page = self.captureManager.captureType == SBCaptureTypeVideo ? 0 : 1;
    [self.cameraView.pageView setIndex:page duration:0];
    
    @weakify(self);
    [RACObserve(self.cameraView.pageView, index) subscribeNext:^(NSNumber *n) {
        @strongify(self);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateForNewPage) object:nil];
        [self performSelectorInBackground:@selector(updateForNewPage) withObject:nil];
        [self showBlur];
    }];
    
    //focus point
    [[self.cameraView focusPointChangeSignal] subscribeNext:^(NSValue *value) {
        @strongify(self);
        CGPoint point = [value CGPointValue];
        [self.captureManager setFocusMode:AVCaptureFocusModeAutoFocus pointOfInterest:point];
    }];
    [self.cameraView setShouldUpdateFocusPosition:^BOOL(CGPoint toPosition) {
        @strongify(self)
        return [self.captureManager isFocusModeAvailable:AVCaptureFocusModeAutoFocus];
    }];
    [self.cameraView setShouldAllowPageViewIndexChange:^BOOL(NSInteger fromIndex, NSInteger toIndex) {
        @strongify(self);
        BOOL allowPhoto = (self.allowedCaptureTypes & SBCaptureTypePhoto) != 0;
        BOOL allowVideo = (self.allowedCaptureTypes & SBCaptureTypeVideo) != 0;
        return  (allowPhoto && allowVideo) || //allow all indexes if all enabled
                (allowPhoto && toIndex != 0) || //allow photo indexes if photo enabled
                (allowVideo && toIndex == 0); //allow video index if video enabled
    }];
    
    [[self.cameraView doubleTapSignal] subscribeNext:^(id _) {
        @strongify(self);
        [self switchCamera];
    }];
    
    //flash mode
    [[RACObserve(self.captureManager, flashMode) skip:1] subscribeNext:^(NSNumber *n) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            SBCaptureFlashMode mode = n.integerValue;
            self.cameraView.flashMode = mode;
        });
    }];
    
    //enable/disable record button when time is at max duration
    [[[[self.captureManager.videoManager totalTimeRecordedSignal] deliverOn:[RACScheduler mainThreadScheduler]] map:^NSNumber*(NSValue* value) {
        @strongify(self);
        return @(CMTimeGetSeconds([value CMTimeValue]) < self.captureManager.videoManager.maxDuration);
    }] subscribeNext:^(NSNumber *enabled) {
        @strongify(self);
        self.cameraView.recordButton.enabled = enabled.boolValue;
    }];
    
    RAC(self.cameraView.progressBar, value) = [[[self.captureManager.videoManager recordDurationChangeSignal] skip:1] map:^id(NSValue* value) {
        return @(CMTimeGetSeconds([value CMTimeValue]));
    }];

    CGFloat const alphaAnimDur = 0.3f;
    [RACObserve(self.cameraView.progressBar, value) subscribeNext:^(NSNumber *n) {
        @strongify(self);
        NSTimeInterval elapsed = n.floatValue;
        NSInteger mins = elapsed / 60;
        NSInteger secs = elapsed - mins;
        self.cameraView.timeLabel.text = secs <= 9 ? [NSString stringWithFormat:@"%d:0%d", mins, secs] : [NSString stringWithFormat:@"%d:%d", mins, secs];
        
        
        if (elapsed > 0 && self.cameraView.pageView.alpha == 1) {
            [UIView animateWithDuration:alphaAnimDur delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
                self.cameraView.pageView.alpha = 0;
                self.cameraView.timeLabel.alpha = 1;
                self.cameraView.nextButton.alpha = 1;
            } completion:nil];
        } else if (elapsed == 0 && self.cameraView.timeLabel.alpha == 1) {
            [UIView animateWithDuration:alphaAnimDur delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
                self.cameraView.pageView.alpha = 1;
                self.cameraView.timeLabel.alpha = 0;
                self.cameraView.nextButton.alpha = 0;
            } completion:nil];
        }
        
        if (elapsed > 0 && self.cameraView.toggleRatioButton.alpha == 1) {
            [UIView animateWithDuration:alphaAnimDur delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
                self.cameraView.toggleRatioButton.alpha = 0;
            } completion:nil];
        } else if (elapsed == 0 && self.cameraView.captureType == SBCaptureTypeVideo && self.cameraView.toggleRatioButton.alpha == 0) {
            [UIView animateWithDuration:alphaAnimDur delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
                self.cameraView.toggleRatioButton.alpha = 1;
            } completion:nil];
        }
    }];
    
    //listen for device position changes (rear & front)
    [RACObserve(self.captureManager, devicePosition) subscribeNext:^(NSNumber *pos) {
        @strongify(self);
        AVCaptureDevicePosition position = (AVCaptureDevicePosition) pos.integerValue;
        if (![self.captureManager.currentManager.currentCamera isFlashModeSupported:AVCaptureFlashModeOn]) {
            self.cameraView.flashModeButton.alpha = .5;
            self.cameraView.flashModeButton.enabled = NO;
        } else {
            self.cameraView.flashModeButton.alpha = 1;
            self.cameraView.flashModeButton.enabled = YES;
        }
    }];
    
    RAC(self.cameraView, squareVideoOffsetBottom) = RACObserve(self.captureManager.videoManager, squareVideoOffsetBottom);
    RAC(self.captureManager.videoManager, squareVideoSize) = [RACObserve(self.cameraView, frame) map:^NSNumber*(NSValue *value) {
        CGRect frame = [value CGRectValue];
        CGFloat min = MIN(frame.size.width, frame.size.height);
        return @(min);
    }];
    
    [self.captureManager.captureSession startRunning];
}

- (void) pushReviewControllerWithAsset:(SBAsset*)asset {
    SBReviewController *vc = [[SBReviewController alloc] initWithAsset:asset];
    vc.reviewOptions = self.reviewOptions;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.cameraView.captureView addSessionIfNeeded:self.captureManager.captureSession];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraView.captureView removeSession];
}

#pragma mark - Camera state handling
- (void) updateUIForNewPage {
    NSInteger page = self.cameraView.pageView.index;
    switch (page) {
        case 0: [self.cameraView setVideoCaptureTypeWithAspectRatio:self.captureManager.videoManager.aspectRatio]; break;
        case 1: [self.cameraView setPhotoCaptureTypeWithAspectRatio:SBCameraAspectRatioNormal]; break;
        case 2: [self.cameraView setPhotoCaptureTypeWithAspectRatio:SBCameraAspectRatioSquare]; break;
        default: break;
    }
    [self.cameraView.recordButton setBorderColor:page == 0 ? [UIColor redColor] : [UIColor fc_stageblocBlueColor]];
    
    
    RACSignal *permissionsSignal;
    if (page == 0) {
        permissionsSignal = [RACSignal merge:@[[AVCaptureDevice rac_requestAccessForVideoMediaType], [AVCaptureDevice rac_requestAccessForAudioMediaType]]];
    } else {
        permissionsSignal = [AVCaptureDevice rac_requestAccessForVideoMediaType];
    }
    
    @weakify(self);
    [[permissionsSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        //ignoring
    } error:^(NSError *error) {
        //don't have acess to media type -
        @strongify(self);
        NSString *type = error.userInfo[@"type"];
        self.accessController.mediaType = type;
        
        if ([type isEqualToString:AVMediaTypeAudio]) {
            [self.cameraView.gestureRecognizers setValue:@YES forKey:NSStringFromSelector(@selector(enabled))];
            [self.cameraView bringSubviewToFront:self.cameraView.pageView];
        } else {
            [self.cameraView.gestureRecognizers setValue:@NO forKey:NSStringFromSelector(@selector(enabled))];
            [self.cameraView bringSubviewToFront:self.accessController.view];
        }
        
        [UIView animateWithDuration:0.25f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            self.accessController.view.alpha = 1;
        } completion:nil];
    } completed:^{
        [UIView animateWithDuration:0.25f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            self.accessController.view.alpha = 0;
        } completion:nil];
    }];
    
}
- (void) updateForNewPage {
    NSInteger page = self.cameraView.pageView.index;
    switch (page) {
        case 0:
            self.captureManager.captureType = SBCaptureTypeVideo;
            self.cameraView.recordButton.allowHold = YES;
            break;
        case 1:
            self.captureManager.captureType = SBCaptureTypePhoto;
            self.captureManager.photoManager.aspectRatio = SBCameraAspectRatioNormal;
            self.cameraView.recordButton.allowHold = NO;
            break;
        case 2:
            self.captureManager.captureType = SBCaptureTypePhoto;
            self.captureManager.photoManager.aspectRatio = SBCameraAspectRatioSquare;
            self.cameraView.recordButton.allowHold = NO;
            break;
        default:
            break;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUIForNewPage) object:nil];
    [self performSelectorOnMainThread:@selector(updateUIForNewPage) withObject:nil waitUntilDone:NO];
}

-(void)switchCamera {
    [self showBlur];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_switchCamera) object:nil];
    [self performSelectorOnMainThread:@selector(_switchCamera) withObject:nil waitUntilDone:NO];
}

- (void) _switchCamera {
    AVCaptureDevicePosition current = self.captureManager.devicePosition;
    self.captureManager.devicePosition = current == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}

- (void) showBlur {
    self.cameraView.stateToolbar.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeBlur) object:nil];
    [self performSelector:@selector(removeBlur) withObject:nil afterDelay:1.f];
}

-(void)removeBlur {
    self.cameraView.stateToolbar.hidden = YES;
}

#pragma mark - HUD
- (SBOverlayView*) showHudWithText:(NSString*)text {
    [self.overlayHud dismiss];
    self.overlayHud = [SBOverlayView showInView:self.view text:text dismissOnTap:YES];
    [self.overlayHud.dismissButton setTitle:@"cancel" forState:UIControlStateNormal];
    
    @weakify(self);
    void (^ notificationHandler)(NSNotification*) = ^(NSNotification *note) {
        @strongify(self);
        UIInterfaceOrientation orientation = [[UIDevice currentDevice] interfaceOrientation];
        if (orientation == -1 || self.overlayHud.superview == nil)
            return;
        
        ALDimension height;
        ALDimension width;
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                height = ALDimensionWidth;
                width = ALDimensionHeight;
                break;
            default:
                height = ALDimensionHeight;
                width = ALDimensionWidth;
                break;
        }
        
        CGFloat offset = 0;
        [self.overlayHud.showConstraints autoRemoveConstraints];
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[self.overlayHud autoCenterInSuperview]];
        [constraints addObject:[self.overlayHud autoMatchDimension:ALDimensionHeight toDimension:height ofView:self.view withOffset:offset]];
        [constraints addObject:[self.overlayHud autoMatchDimension:ALDimensionWidth toDimension:width ofView:self.view withOffset:offset]];
        self.overlayHud.showConstraints = [constraints copy];
        
        [self.overlayHud setDefaultAutolayoutWithCloseButtonOffset:-(15 + offset)];
        
        NSTimeInterval duration = 0.5f;
        if ([note isKindOfClass:[NSDictionary class]]) duration = [[note valueForKey:@"duration"] floatValue];
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            self.overlayHud.transform = CGAffineTransformMakeRotation([UIDevice rotationForInterfaceOrientation:orientation]);
            [self.view layoutIfNeeded];
        } completion:nil];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:notificationHandler];
    notificationHandler(@{@"duration":@(0)});
    
    return self.overlayHud;
}

#pragma mark - Camera Actions 
- (void) startRecording {
    SBVideoManager *manager = self.captureManager.videoManager;
    if (manager.isPaused) {
        [manager resumeRecording];
    } else  {
        [manager startRecording];
    }
    [self.cameraView animateHudHidden:YES completion:nil];
}

- (void) pauseRecording {
    [self.captureManager.videoManager pauseRecording];
    [self.cameraView animateHudHidden:NO completion:nil];
}

- (void) stopRecording {
    [self.captureManager.videoManager pauseRecording];
}

- (void) capturePhoto {
    if (self.captureManager.captureType != SBCaptureTypePhoto)
        return;
    
    self.view.userInteractionEnabled = NO;
    [self.cameraView animateShutterWithDuration:.1 completion:nil];
    @weakify(self);
    [[self.captureManager.photoManager captureImage] subscribeNext:^(UIImage *image) {
        @strongify(self);
        SBAsset *asset = [[SBAsset alloc] initWithImage:image type:SBAssetTypeImage];
        [self pushReviewControllerWithAsset:asset];
    } error:^(NSError *error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
    } completed:^{
        @strongify(self);
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - User Actions
- (void) launchNeedPhotosAccess {
    UIAlertView *alert;
    if ([UIApplication canOpenSettings]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Photo permission are required" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:@"Update", nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Photo permission are required" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    }
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        if (alert.cancelButtonIndex == buttonIndex.integerValue)
            return;
        [[UIApplication sharedApplication] openSettings];
    }];
    [alert show];
}

- (void) launchChooseExistingSheet {
    @weakify(self);
    
    /* Not using this for now - may be used in future
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Taken", @"All Photos", nil];
    
    [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *i) {
        @strongify(self);
        UIActionSheet *a = actionSheet;
        NSInteger index = i.integerValue;
        if (index != a.cancelButtonIndex) {
            if (index == 0) {
                [[self.assetManager.fetchLastPhoto deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
                    @strongify(self);
                    SBAsset *asset = [[SBAsset alloc] initWithImage:image type:SBAssetTypeImage];
                    [self pushReviewControllerWithAsset:asset];
                } error:^(NSError *error) {
                    @strongify(self);
                    NSLog(@"ERROR: %@", error);
                } completed:^{
                    NSLog(@"completed fetch last photo");
                }];
            } else {
                SBImagePickerController *picker = [[SBImagePickerController alloc] init];
                [[picker imageSelectSignal] subscribeNext:^(UIImage *image) {
                    @strongify(self);
                    if ([image  isKindOfClass:[UIImage class]]) {
                        SBAsset *asset = [[SBAsset alloc] initWithImage:image type:SBAssetTypeImage];
                        [self pushReviewControllerWithAsset:asset];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                } error:^(NSError *error) {
                    @strongify(self);
                    [self dismissViewControllerAnimated:YES completion:nil];
                } completed:^{
                    @strongify(self);
                    if (self.presentedViewController)
                        [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }];
    [actionSheet showInView:self.view];
    */
    
    SBImagePickerController *picker = [[SBImagePickerController alloc] init];
    
    void (^dismissPicker)(void) = ^{
        picker.hideStatusBar = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [picker setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

    };
    
    @weakify(picker);
    [[[picker imageSelectSignal]
        deliverOnMainThread]
        subscribeNext:^(UIImage *image) {
            @strongify(self);
            @strongify(picker);
            if ([image  isKindOfClass:[UIImage class]]) {
                SBAsset *asset = [[SBAsset alloc] initWithImage:image type:SBAssetTypeImage];
                [self pushReviewControllerWithAsset:asset];
                dismissPicker();
            }
        } error:^(NSError *error) {
            @strongify(self);
            dismissPicker();
        } completed:^{
            @strongify(self);
            if (self.presentedViewController) {
                dismissPicker();
            }
        }];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)chooseExistingButtonPressed:(id)sender {
    @weakify(self);
    
    //use responds too
    RACSignal *signal;
    if ([[UIDevice currentDevice] isAtLeastiOS:8]) {
        signal = [PHPhotoLibrary rac_requestAccess];
    } else {
        signal = [ALAssetsLibrary rac_requestAccess];
    }
    
    [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id _) {
    } error:^(NSError *error) {
        @strongify(self);
        [self launchNeedPhotosAccess];
    } completed:^{
        @strongify(self);
        [self launchChooseExistingSheet];
    }];
}

-(void)flashModeButtonPressed:(UIButton *)sender {
    [self.captureManager cycleFlashMode];
}

-(void)cameraToggleButtonPressed:(UIButton *)sender {
    [self switchCamera];
}

- (void)ratioToggleButtonPressed:(UIButton*)sender {
    //shouldn't happen - but just in case
    if (self.cameraView.captureType != SBCaptureTypeVideo)
        return;
    
    switch (self.captureManager.videoManager.aspectRatio) {
        case SBCameraAspectRatioNormal: self.captureManager.videoManager.aspectRatio = SBCameraAspectRatioSquare; break;
        default: self.captureManager.videoManager.aspectRatio = SBCameraAspectRatioNormal; break;
    }
    self.cameraView.aspectRatio = self.captureManager.videoManager.aspectRatio;
}

- (void) nextButtonPressed:(UIButton*)sender {
    if (![self.captureManager.videoManager isPastMinDuration]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"The minimum duration has not been reached" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
        return;
    }
    
    @weakify(self);
    SBOverlayView *overlayView = [self showHudWithText:@"Processing video"];
    [[[self.captureManager.videoManager finalizeRecordingToFile:[NSURL randomDocumentsFileURLWithPrefix:@"final" extension:@"mp4"] takeUntil:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [overlayView setOnDismissTap:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }]] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSURL *saveURL) {
        @strongify(self);
        SBAsset *asset = [[SBAsset alloc] initWithFileURL:saveURL type:SBAssetTypeVideo];
        [self pushReviewControllerWithAsset:asset];
    } error:^(NSError *error) {
        @strongify(self);
        [self.overlayHud dismissAfterError:@"Error processing video"];
    } completed:^{
        @strongify(self);
        [self.overlayHud dismiss];
        [self.captureManager.videoManager reset];
    }];
}

-(void)closeButtonPressed:(id)sender {
    if (CMTimeGetSeconds(self.captureManager.videoManager.totalRecordingDuration) > 0) {
        @weakify(self);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This will delete your current recording" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
            @strongify(self);
            if (alert.cancelButtonIndex == buttonIndex.integerValue)
                return;
            
            [self.captureManager.videoManager reset];
            if ([self.delegate respondsToSelector:@selector(cameraControllerCancelled:)]) {
                [self.delegate cameraControllerCancelled:self];
            }
        }];
        [alert show];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(cameraControllerCancelled:)]) {
        [self.delegate cameraControllerCancelled:self];
    }
}

#pragma mark - SCRecordButtonDelegate
- (void) recordButtonStartedHolding:(SBRecordButton *)button {
    //only accept video mode for this logic
    if (self.captureManager.captureType != SBCaptureTypeVideo)
        return;
    
    [self startRecording];
}

- (void) recordButtonStoppedHolding:(SBRecordButton *)button {
    if (self.captureManager.captureType == SBCaptureTypePhoto) {
        [self capturePhoto];
    } else {
        [self pauseRecording];
    }
}

- (void) recordButtonTapped:(SBRecordButton *)button {
    //only accept photo mode for this logic
    if (self.captureManager.captureType != SBCaptureTypePhoto)
        return;
    
    [self capturePhoto];
}

#pragma mark - SBReviewControllerDelegate
- (void) reviewController:(SBReviewController *)controller acceptedAsset:(SBAsset *)asset {
    if ([self.delegate respondsToSelector:@selector(reviewController:acceptedAsset:)]) {
        [self.delegate reviewController:controller acceptedAsset:asset];
    }
}

- (void) reviewController:(SBReviewController *)controller rejectedAsset:(SBAsset *)asset {
    controller.view.userInteractionEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSFileManager defaultManager] removeItemAtURL:asset.fileURL error:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animator.type = SBAnimatorTypePresent;
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.type = SBAnimatorTypeDismiss;
    return self.animator;
}

#pragma mark - UINavigationViewControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPop:
            self.navAnimator.type = SBAnimatorTypePop;
            break;
        case UINavigationControllerOperationPush:
            self.navAnimator.type = SBAnimatorTypePush;
            break;
        default:
            break;
    }
    UIInterfaceOrientation orietnation = [[UIDevice currentDevice] interfaceOrientation];
    if ((NSInteger)orietnation == -1) orietnation = UIInterfaceOrientationPortrait;
    switch (orietnation) {
        case UIInterfaceOrientationPortrait:
            self.navAnimator.direction = SBPushAnimatorDirectionRight;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.navAnimator.direction = SBPushAnimatorDirectionLeft;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            self.navAnimator.direction = SBPushAnimatorDirectionDown;
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.navAnimator.direction = SBPushAnimatorDirectionUp;
            break;
        default:
            break;
    }
    return self.navAnimator;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [UIView performWithoutAnimation:^{
        [viewController setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [UIView performWithoutAnimation:^{
        [viewController setNeedsStatusBarAppearanceUpdate];
    }];
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
