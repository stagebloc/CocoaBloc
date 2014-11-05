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

@import AVFoundation.AVCaptureVideoPreviewLayer;

@implementation SCCameraView

- (SCProgressBar*) progressBar {
    if (!_progressBar) {
        _progressBar = [[SCProgressBar alloc] initWithMinValue:0 maxValue:10];
    }
    return _progressBar;
}

- (UIButton*) recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.backgroundColor = [UIColor whiteColor];
        _recordButton.layer.masksToBounds = YES;
    }
    return _recordButton;
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

- (UIButton*) closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.imageView.contentMode = UIViewContentModeCenter;
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.layer.masksToBounds = YES;
    }
    return _closeButton;
}

- (UISwitch*) toggleSwitch {
    if (!_toggleSwitch) {
        _toggleSwitch = [[UISwitch alloc] init];
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
        _shutterToolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
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
        _optionsButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _optionsButton;
}

#pragma mark - Toolbar views
- (UIToolbar*) toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 0.0f)];
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
        _adjustFlashModeButton.tag = 0;
    }
    return _adjustFlashModeButton;
}

- (UIButton*) toggleCameraButton {
    if (!_toggleCameraButton) {
        _toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleCameraButton.frame = CGRectMake(CGRectGetWidth(_toolbar.bounds)/2 - 15.f, 15.f, 30.0, 30.0);
        [_toggleCameraButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
        _toggleCameraButton.contentMode = UIViewContentModeCenter;
    }
    return _toggleCameraButton;
}

- (void) initializeViews {
    CGFloat buttonWH = 30;
    
    //shutter toolbar
    [self addSubview:self.shutterToolbar];
    
    //top overlay view
    [self addSubview:self.topOverlayView];
    [self.topOverlayView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0.f];
    [self.topOverlayView autoSetDimension:ALDimensionHeight toSize:44.f];
    [self.topOverlayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.topOverlayView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withOffset:0.0];
    
    //bottom overlay view
    [self addSubview:self.bottomOverlayView];
    [self.bottomOverlayView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0.f];
    [self.bottomOverlayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.bottomOverlayView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(self.bounds) - CGRectGetWidth(self.bounds) - 44.f];
    [self.bottomOverlayView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withOffset:0.0];
    
    //progress bar
    [self addSubview:self.progressBar];
    [self.progressBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.progressBar autoSetDimension:ALDimensionHeight toSize:5.0f];
    [self.progressBar autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.progressBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    
    //tool bar
    [self addSubview:self.toolbar];
    [self.toolbar addSubview:self.toggleAspectRatioButton];
    [self.toolbar addSubview:self.adjustFlashModeButton];
    [self.toolbar addSubview:self.toggleCameraButton];
    
    //toggle switch
    [self addSubview:self.toggleSwitch];
    [self.toggleSwitch autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10.0f];
    [self.toggleSwitch autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:(self.frame.size.width/2) - (self.toggleSwitch.frame.size.width/2)];
    
    //record button
    [self addSubview:self.recordButton];
    [self.recordButton autoSetDimension:ALDimensionWidth toSize:64.f];
    [self.recordButton autoSetDimension:ALDimensionHeight toSize:64.f];
    [self.recordButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.recordButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-60.f];
    
    //choose existing button
    [self addSubview:self.chooseExistingButton];
    [self.chooseExistingButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15.f];
    [self.chooseExistingButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-15.f];
    [self.chooseExistingButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.chooseExistingButton autoSetDimension:ALDimensionWidth toSize:buttonWH];
    
    //close button
    [self addSubview:self.closeButton];
    [self.closeButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.closeButton autoSetDimension:ALDimensionWidth toSize:buttonWH];
    [self.closeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15.f];
    [self.closeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:15.f];
    
    [self addSubview:self.optionsButton];
    [self.optionsButton autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [self.optionsButton autoSetDimension:ALDimensionWidth toSize:buttonWH];
    [self.optionsButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15.f];
    [self.optionsButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-15.f];
}

- (id) initWithFrame:(CGRect)frame CaptureManager:(SCCaptureManager*)captureManager {
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

- (void)layoutSubviews {
    [super layoutSubviews];
    _recordButton.layer.cornerRadius = CGRectGetHeight(_recordButton.frame) / 2;
}

#pragma mark - Animations 
-(void)animateUp:(void(^)(BOOL finished))completion
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
                         CGFloat height = CGRectGetMaxY(self.bounds) - yOffset;
                         _toolbar.frame = CGRectMake(self.frame.origin.x, yOffset, self.frame.size.width, height);                 }
                     completion:^(BOOL finished){
                         if (completion)
                             completion(finished);
                     }];
}

-(void)animateDown:(void(^)(BOOL finished))completion
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
                         _toolbar.frame = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 0.0f);
                     }
                     completion:^(BOOL finished){
                         if (completion)
                             completion(finished);
                     }];
}

@end
