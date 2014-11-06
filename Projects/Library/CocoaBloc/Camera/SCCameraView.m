//
//  SCCameraView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SCCameraView.h"
#import "SCProgressBar.h"
#import "SCCaptureView.h"
#import "SCCaptureManager.h"
#import <PureLayout/PureLayout.h>
#import "SCRecordButton.h"

@import AVFoundation.AVCaptureVideoPreviewLayer;

@implementation SCCameraView

@synthesize aspectRatio = _aspectRatio;

- (SCProgressBar*) progressBar {
    if (!_progressBar) {
        _progressBar = [[SCProgressBar alloc] initWithMinValue:0 maxValue:10];
    }
    return _progressBar;
}

- (SCRecordButton*) recordButton {
    if (!_recordButton) {
        _recordButton = [[SCRecordButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        _recordButton.layer.masksToBounds = YES;
    }
    return _recordButton;
}

- (UIToolbar*) shutterToolbar {
    if (!_shutterToolbar) {
        _shutterToolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        _shutterToolbar.backgroundColor = [UIColor blackColor];
        _shutterToolbar.barStyle = UIBarStyleBlack;
        _shutterToolbar.hidden = YES;
    }
    return _shutterToolbar;
}

#pragma mark - Top HUD views
- (UIView*) topHudView {
    if (!_topHudView) {
        _topHudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.0f)];
        _topHudView.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
        [_topHudView addSubview:self.closeButton];
    }
    return _topHudView;
}

- (UIButton*) closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.imageView.contentMode = UIViewContentModeCenter;
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.layer.masksToBounds = YES;
    }
    return _closeButton;
}

#pragma mark - Bottom HUD views
- (UIView*) bottomHudView {
    if (!_bottomHudView) {
        _bottomHudView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 0.0f)];
        _bottomHudView.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
        
        CGFloat buttonHW = 30;
        CGFloat offset = 15.0f;
        
        [_bottomHudView addSubview:self.toggleCameraButton];
        [self.toggleCameraButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bottomHudView withOffset:offset];
        [self.toggleCameraButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.toggleCameraButton autoSetDimensionsToSize:CGSizeMake(buttonHW, buttonHW)];
        
        [_bottomHudView addSubview:self.flashModeButton];
        [self.flashModeButton autoSetDimensionsToSize:CGSizeMake(50, buttonHW)];
        [self.flashModeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bottomHudView withOffset:offset];
        [self.flashModeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bottomHudView withOffset:offset];
        
        [_bottomHudView addSubview:self.aspectRatioButton];
        [self.aspectRatioButton autoSetDimensionsToSize:CGSizeMake(buttonHW, buttonHW)];
        [self.aspectRatioButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bottomHudView withOffset:offset];
        [self.aspectRatioButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_bottomHudView withOffset:-offset];

        [_bottomHudView addSubview:self.chooseExistingButton];
        [self.chooseExistingButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bottomHudView withOffset:offset];
        [self.chooseExistingButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_bottomHudView withOffset:-offset];
        [self.chooseExistingButton autoSetDimensionsToSize:CGSizeMake(buttonHW, buttonHW)];
    }
    return _bottomHudView;
}

- (UIButton*) aspectRatioButton {
    if (!_aspectRatioButton) {
        _aspectRatioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aspectRatioButton.frame = CGRectMake(CGRectGetWidth(_bottomHudView.bounds) -45.f, 15.f , 30.0, 30.0);
        _aspectRatioButton.layer.masksToBounds = YES;
        self.aspectRatio = SCCameraAspectRatio4_3;
    }
    return _aspectRatioButton;
}

- (UIButton*) flashModeButton {
    if (!_flashModeButton) {
        _flashModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashModeButton.frame = CGRectMake(CGRectGetMinX(_bottomHudView.bounds) + 15.f, 15.f, 30.0, 30.0);
        _flashModeButton.layer.masksToBounds = YES;
        _flashModeButton.tag = 0;
        _flashModeButton.contentMode = UIViewContentModeCenter;
        self.flashMode = AVCaptureFlashModeOff;
    }
    return _flashModeButton;
}

- (UIButton*) toggleCameraButton {
    if (!_toggleCameraButton) {
        _toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleCameraButton.frame = CGRectMake(CGRectGetWidth(_bottomHudView.bounds)/2 - 15.f, 15.f, 30.0, 30.0);
        [_toggleCameraButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
        _toggleCameraButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _toggleCameraButton;
}

- (UIButton*) chooseExistingButton {
    if (!_chooseExistingButton) {
        _chooseExistingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseExistingButton setImage:[UIImage imageNamed:@"existing"] forState:UIControlStateNormal];
        _chooseExistingButton.layer.masksToBounds = YES;
        _chooseExistingButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _chooseExistingButton;
}

- (void) initializeViews {
    CGFloat buttonWH = 30;
    CGFloat buttonOffset = 5.f;
    
    //BOTTOM HUD (contains subviews)
    [self addSubview:self.bottomHudView];
    [self.bottomHudView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [self.bottomHudView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.bottomHudView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.bottomHudView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.bottomHudView autoSetDimension:ALDimensionHeight toSize:170];
    
    //TOP HUD (contains subviews)
    [self addSubview:self.topHudView];
    [self.topHudView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.topHudView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.topHudView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.topHudView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.topHudView autoSetDimension:ALDimensionHeight toSize:buttonWH+buttonOffset*2];
    //close button in TOP HUD
    [self.closeButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.closeButton autoSetDimension:ALDimensionWidth toSize:buttonWH];
    [self.closeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.topHudView withOffset:buttonOffset];
    [self.closeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.topHudView withOffset:buttonOffset];
    
    //shutter toolbar
    [self addSubview:self.shutterToolbar];
    
    //progress bar
    [self addSubview:self.progressBar];
    [self.progressBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.progressBar autoSetDimension:ALDimensionHeight toSize:5.0f];
    [self.progressBar autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.progressBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
    
    //record button
    [self addSubview:self.recordButton];
    [self.recordButton autoSetDimension:ALDimensionWidth toSize:64.f];
    [self.recordButton autoSetDimension:ALDimensionHeight toSize:64.f];
    [self.recordButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.recordButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-20.f];

}

- (instancetype) initWithFrame:(CGRect)frame captureManager:(SCCaptureManager*)captureManager {
    if (self = [super initWithFrame:frame]) {
        self.captureView = [[SCCaptureView alloc] initWithCaptureSession:captureManager.captureSession];
        [self addSubview:self.captureView];
        [self.captureView autoCenterInSuperview];
        [self.captureView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [self.captureView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
        ((AVCaptureVideoPreviewLayer *)self.captureView.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;

        [self initializeViews];
    }
    return self;
}

- (void) setFlashMode:(AVCaptureFlashMode)flashMode {
    [self willChangeValueForKey:@"flashMode"];
    _flashMode = flashMode;
    [self didChangeValueForKey:@"flashMode"];
    
    switch (flashMode) {
        case AVCaptureFlashModeOff:
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeOn:
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeAuto:
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_auto"] forState:UIControlStateNormal];
            break;
        default: break;
    }
}

- (AVCaptureFlashMode) cycleFlashMode {
    AVCaptureFlashMode newMode = self.flashMode + 1;
    if (newMode > AVCaptureFlashModeAuto)
        newMode = AVCaptureFlashModeOff;
    self.flashMode = newMode;
    return newMode;
}

- (void) setAspectRatio:(SCCameraAspectRatio)aspectRatio {
    [self willChangeValueForKey:@"flashMode"];
    _aspectRatio = aspectRatio;
    [self didChangeValueForKey:@"flashMode"];
    
    switch (aspectRatio) {
        case SCCameraAspectRatio1_1:
            [_aspectRatioButton setImage:[UIImage imageNamed:@"ratio_1_1"] forState:UIControlStateNormal];
            break;
        case SCCameraAspectRatio4_3:
            [_aspectRatioButton setImage:[UIImage imageNamed:@"ratio_4_3"] forState:UIControlStateNormal];
            break;
        default: break;
    }
}

- (SCCameraAspectRatio) cycleAspectRatio {
    SCCameraAspectRatio newMode = self.aspectRatio + 1;
    if (newMode > SCCameraAspectRatio4_3)
        newMode = SCCameraAspectRatio1_1;
    self.aspectRatio = newMode;
    return newMode;
}

- (BOOL) isHudHidden {
    return _bottomHudView.alpha == 0;
}

#pragma mark - Animations
- (void) animateHudHidden:(BOOL)hidden completion:(void (^)(BOOL))completion {
    [self animateHudHidden:hidden duration:0.5f completion:completion];
}

-(void)animateHudHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion {
    CGFloat toValue = hidden ? 0 : 1.0f;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:.5 options:0 animations:^{
        _bottomHudView.alpha = toValue;
        _topHudView.alpha = toValue;
    } completion:^(BOOL finished) {
        if (completion)
            completion(finished);
    }];
}

@end
