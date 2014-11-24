//
//  SCCameraViewController.m
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBCameraViewController.h"
#import "SBCaptureManager.h"
#import "SBCaptureView.h"
#import "SBReviewController.h"
#import "SBImagePickerController.h"
#import "SBAssetsManager.h"
#import "SBCameraView.h"
#import "SBPageView.h"
#import "SBProgressBar.h"
#import "SBRecordButton.h"
#import "SBAlbumViewController.h"
#import "UIColor+FanClub.h"
#import "SBVideoManager.h"
#import "SBPhotoManager.h"
#import "SBOverlayView.h"

#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import <AVFoundation/AVFoundation.h>

@interface SBCameraViewController () <UIActionSheetDelegate, SCRecordButtonDelegate, SBReviewControllerDelegate>

@property (nonatomic, assign) BOOL recording;
@property (nonatomic, strong) SBCaptureManager *captureManager;
@property (nonatomic, strong) SBCameraView *cameraView;

@property (nonatomic, strong) SBOverlayView *overlayHud;

@end

@implementation SBCameraViewController

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
    }
    return _cameraView;
}

- (instancetype) initWithCaptureType:(SBCaptureType)captureType {
    if (self = [super init]) {
        self.captureManager.captureType = captureType;
    }
    return self;
}

#pragma mark - View state
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.cameraView];
    [self.cameraView autoCenterInSuperview];
    [self.cameraView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.cameraView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    
    //set current index to match capture type
    NSInteger page = self.captureManager.captureType == SBCaptureTypeVideo ? 0 : 1;
    [self.cameraView.pageView setIndex:page duration:0];
    
    @weakify(self);
    [RACObserve(self.cameraView.pageView, index) subscribeNext:^(NSNumber *n) {
        @strongify(self);
        NSInteger index = n.integerValue;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUIForNewPage) object:nil];
        [self performSelectorOnMainThread:@selector(updateUIForNewPage) withObject:nil waitUntilDone:NO];
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
    
    //hide next button if video time isn't past minimum required time
    [[[self.captureManager.videoManager totalTimeRecordedSignal] map:^NSNumber*(id _) {
        @strongify(self);
        return @(!self.captureManager.videoManager.isPastMinDuration);
    }] subscribeNext:^(NSNumber *hidden) {
        @strongify(self);
        self.cameraView.nextButton.hidden = hidden.boolValue;
    }];
    
    //enable/disable record button when time is at max duration
    [[[self.captureManager.videoManager totalTimeRecordedSignal] map:^NSNumber*(NSNumber* value) {
        @strongify(self);
        return @(!(CMTimeGetSeconds([value CMTimeValue]) >= self.captureManager.videoManager.maxDuration));
    }] subscribeNext:^(NSNumber *enabled) {
        @strongify(self);
        self.cameraView.recordButton.enabled = enabled.boolValue;
    }];
    
    RAC(self.cameraView.progressBar, value) = [[[self.captureManager.videoManager recordDurationChangeSignal] skip:1] map:^id(id value) {
        return @(CMTimeGetSeconds([value CMTimeValue]));
    }];

    [RACObserve(self.cameraView.progressBar, value) subscribeNext:^(NSNumber *n) {
        @strongify(self);
        NSTimeInterval elapsed = n.floatValue;
        NSInteger mins = elapsed / 60;
        NSInteger secs = elapsed - mins;
        self.cameraView.timeLabel.text = secs <= 9 ? [NSString stringWithFormat:@"%d:0%d", mins, secs] : [NSString stringWithFormat:@"%d:%d", mins, secs];
        BOOL shouldHidePageView = (secs > 0 || mins > 0);
        self.cameraView.pageView.hidden = shouldHidePageView;
        self.cameraView.timeLabel.hidden = !shouldHidePageView;
    }];
    
    [self.captureManager.captureSession startRunning];
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
        case 0:
            self.captureManager.captureType = SBCaptureTypeVideo;
            self.cameraView.recordButton.allowHold = YES;
            [self.cameraView setVideoCaptureType];
            break;
        case 1:
            self.captureManager.captureType = SBCaptureTypePhoto;
            self.captureManager.photoManager.aspectRatio = SBCameraAspectRatio4_3;
            self.cameraView.recordButton.allowHold = NO;
            [self.cameraView setPhotoCaptureTypeWithAspectRatio:SBCameraAspectRatio4_3];
            break;
        case 2:
            self.captureManager.captureType = SBCaptureTypePhoto;
            self.captureManager.photoManager.aspectRatio = SBCameraAspectRatio1_1;
            self.cameraView.recordButton.allowHold = NO;
            [self.cameraView setPhotoCaptureTypeWithAspectRatio:SBCameraAspectRatio1_1];
            break;
        default:
            break;
    }
    [self.cameraView.recordButton setBorderColor:page == 0 ? [UIColor redColor] : [UIColor fc_stageblocBlueColor]];
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
    self.cameraView.stateToolbar.backgroundColor = [UIColor clearColor];
    self.cameraView.stateToolbar.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeBlur) object:nil];
    [self performSelector:@selector(removeBlur) withObject:nil afterDelay:1.f];
}

-(void)removeBlur {
    self.cameraView.stateToolbar.backgroundColor = [UIColor blackColor];
    self.cameraView.stateToolbar.hidden = YES;
}

#pragma mark - HUD
- (void) showHudWithText:(NSString*)text {
    [self.overlayHud dismiss];
    self.overlayHud = [SBOverlayView showInView:self.view text:text];
}

#pragma mark - Camera Actions 
- (void) startRecording {
    NSLog(@"Started recording");
    SBVideoManager *manager = self.captureManager.videoManager;
    if (manager.isPaused) {
        [manager resumeRecording];
    } else  {
        [manager startRecording];
    }
    [self.cameraView animateHudHidden:YES completion:nil];
}

- (void) pauseRecording {
    NSLog(@"Stopped recording");
    [self.captureManager.videoManager pauseRecording];
    [self.cameraView animateHudHidden:NO completion:nil];
}

- (void) stopRecording {
    [self.captureManager.videoManager pauseRecording];
}

- (void) capturePhoto {
    [self.cameraView animateShutterWithDuration:.1 completion:nil];
    [self showHudWithText:@"Processing image"];
    @weakify(self);
    [[self.captureManager.photoManager captureImage] subscribeNext:^(UIImage *image) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.overlayHud dismiss];
        });
        SBReviewController *vc = [[SBReviewController alloc] initWithImage:image];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } error:^(NSError *error) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.overlayHud dismissAfterError:@"Error processing image"];
        });
    }];
}

#pragma mark - User Actions
-(void)chooseExistingButtonPressed:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Taken", @"All Photos", nil];
    actionSheet.delegate = (id<UIActionSheetDelegate>)actionSheet;
    [[actionSheet rac_signalForSelector:@selector(actionSheet:didDismissWithButtonIndex:) fromProtocol:@protocol(UIActionSheetDelegate)] subscribeNext:^(RACTuple *t) {
        UIActionSheet *a = t.first;
        NSInteger index = [t.second integerValue];
        if (index != a.cancelButtonIndex) {
            if (index == 0) {
                [[[[SBAssetsManager sharedInstance] fetchLastPhoto] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
                    SBReviewController *vc = [[SBReviewController alloc] initWithImage:image];
                    vc.delegate = self;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } error:^(NSError *error) {
                    NSLog(@"ERROR: %@", error);
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SBImagePickerController *picker = [[SBImagePickerController alloc] init];
                    picker.completionBlock = ^(UIImage *image, NSDictionary *info) {
                        if (image) {
                            SBReviewController *vc = [[SBReviewController alloc] initWithImage:image];
                            vc.delegate = self;
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
    [self.captureManager cycleFlashMode];
}

-(void)cameraToggleButtonPressed:(UIButton *)sender {
    [self switchCamera];
}

- (void) nextButtonPressed:(UIButton*)sender {
    if (![self.captureManager.videoManager isPastMinDuration]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"The minimum duration has not been reached" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@-%ld.mp4", NSTemporaryDirectory(), @"final", (long)[[NSDate date] timeIntervalSince1970]]];
    [self showHudWithText:@"Processing video"];
    @weakify(self);
    [[self.captureManager.videoManager finalizeRecordingToFile:url] subscribeNext:^(NSURL *saveURL) {
        @strongify(self);
        NSLog(@"Saved locally");
        [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:saveURL completionBlock:^(NSURL *assetURL, NSError *error) {
            @strongify(self);
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.overlayHud dismissAfterError:@"Error saving to library"];
                });
                NSLog(@"couldn't save to library - %@", error.localizedDescription);
                return;
            }
            
            NSLog(@"saved to library");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.overlayHud dismissAfterText:@"Saved to library"];
            });
        }];
    } error:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.overlayHud dismissAfterError:@"Error processing video"];
        });
        NSLog(@"Failed to save locally - %@", error.localizedDescription);
        [[[UIAlertView alloc] initWithTitle:@"Failed" message:@"Video was not saved to library" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }];
}

-(void)closeButtonPressed:(id)sender {
    if (CMTimeGetSeconds(self.captureManager.videoManager.totalRecordingDuration) > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait!" message:@"Would you like to cancel your current recording?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
            if (alert.cancelButtonIndex == buttonIndex.integerValue)
                return;
            [self.captureManager.videoManager reset];
        }];
        [alert show];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidFinish:)]) {
        [self.delegate cameraViewControllerDidFinish:self];
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
- (void) reviewController:(SBReviewController *)controller acceptedImage:(UIImage *)image title:(NSString *)title description:(NSString *)description {
//    NSDictionary *info = @{@"title" : title, @"description" : description};
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SHOULD Override Image Saved to Device" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) reviewController:(SBReviewController *)controller rejectedImage:(UIImage *)image {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Status bar states
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
