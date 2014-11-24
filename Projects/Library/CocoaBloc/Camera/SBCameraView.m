//
//  SCCameraView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBCameraView.h"
#import "SBProgressBar.h"
#import "SBCaptureView.h"
#import "SBCaptureManager.h"
#import <PureLayout/PureLayout.h>
#import "SBRecordButton.h"
#import "UIFont+FanClub.h"
#import "UIColor+FanClub.h"
#import "SBPageView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@import AVFoundation.AVCaptureVideoPreviewLayer;

@interface SBCameraView ()
@property (nonatomic, strong) NSArray *cameraConstraints;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightGesture;

@end

@implementation SBCameraView

@synthesize aspectRatio = _aspectRatio;

- (UIView*) captureViewContainer {
    if (!_captureViewContainer) {
        _captureViewContainer = [[UIView alloc] initWithFrame:self.bounds];
        _captureViewContainer.backgroundColor = [UIColor clearColor];
    }
    return _captureViewContainer;
}

- (SBProgressBar*) progressBar {
    if (!_progressBar) {
        _progressBar = [[SBProgressBar alloc] initWithMinValue:0 maxValue:10];
        _progressBar.progressView.backgroundColor = [UIColor fc_stageblocBlueColor];
    }
    return _progressBar;
}

- (SBRecordButton*) recordButton {
    if (!_recordButton) {
        _recordButton = [[SBRecordButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        _recordButton.layer.masksToBounds = YES;
    }
    return _recordButton;
}

- (UIToolbar*) stateToolbar {
    if (!_stateToolbar) {
        _stateToolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        _stateToolbar.backgroundColor = [UIColor blackColor];
        _stateToolbar.barStyle = UIBarStyleBlack;
        _stateToolbar.hidden = YES;
    }
    return _stateToolbar;
}

- (UIView*) shutterView {
    if (!_shutterView) {
        _shutterView = [[UIView alloc] initWithFrame:self.bounds];
        _shutterView.backgroundColor = [UIColor blackColor];
        _shutterView.alpha = 0;
    }
    return _shutterView;
}

- (UIView*) focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.alpha = 0;
        _focusView.layer.borderColor = [UIColor whiteColor].CGColor;
        _focusView.layer.borderWidth = 2.0f;
        _focusView.layer.cornerRadius = 40;
    }
    return _focusView;
}

#pragma mark - Top HUD views
- (UIView*) topHudView {
    if (!_topHudView) {
        _topHudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.0f)];
        _topHudView.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
        
        CGFloat const buttonWH = 30;
        CGFloat const buttonOffset = 5.f;
        CGFloat const hudHeight = buttonWH+buttonOffset*2;
        
        [_topHudView autoSetDimension:ALDimensionHeight toSize:hudHeight];
        
        [_topHudView addSubview:self.closeButton];
        [self.closeButton autoSetDimensionsToSize:CGSizeMake(buttonWH, buttonWH)];
        [self.closeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_topHudView withOffset:buttonOffset];
        [self.closeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_topHudView withOffset:buttonOffset];

        [_topHudView addSubview:self.toggleCameraButton];
        [self.toggleCameraButton autoSetDimensionsToSize:CGSizeMake(buttonWH, buttonWH)];
        [self.toggleCameraButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_topHudView withOffset:-buttonOffset];
        [self.toggleCameraButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_topHudView withOffset:buttonOffset];
        
        [_topHudView addSubview:self.timeLabel];
        [self.timeLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_topHudView];
        [self.timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_topHudView];
        
        [_topHudView addSubview:self.pageView];
        [self.pageView autoAlignAxis:ALAxisVertical toSameAxisOfView:_topHudView];
        [self.pageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_topHudView];
        [self.pageView autoSetDimensionsToSize:CGSizeMake(225, hudHeight)];
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

- (UIButton*) toggleCameraButton {
    if (!_toggleCameraButton) {
        _toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleCameraButton.frame = CGRectMake(CGRectGetWidth(_bottomHudView.bounds)/2 - 15.f, 15.f, 30.0, 30.0);
        [_toggleCameraButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
        _toggleCameraButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _toggleCameraButton;
}

- (UILabel*) timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont fc_fontWithSize:19.0f];
        _timeLabel.text = @"0:00";
    }
    return _timeLabel;
}

- (SBPageView*) pageView {
    if (!_pageView) {
        _pageView = [[SBPageView alloc] initWithTitles:@[@"Video", @"Photo", @"Square"]];
    }
    return _pageView;
}

#pragma mark - Bottom HUD views
- (UIView*) bottomHudView {
    if (!_bottomHudView) {
        _bottomHudView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 0.0f)];
        _bottomHudView.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
        
        CGSize size = CGSizeMake(30, 30);
        CGFloat offset = 15.0f;
        
        [_bottomHudView addSubview:self.chooseExistingButton];
        [self.chooseExistingButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bottomHudView withOffset:offset];
        [self.chooseExistingButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_bottomHudView withOffset:-offset];
        [self.chooseExistingButton autoSetDimensionsToSize:size];
        
        [_bottomHudView addSubview:self.flashModeButton];
        [self.flashModeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_bottomHudView withOffset:-offset];
        [self.flashModeButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_bottomHudView withOffset:-offset];
        [self.flashModeButton autoSetDimensionsToSize:size];
        
        size = CGSizeMake(64, 64);
        offset = 20;
        [_bottomHudView addSubview:self.recordButton];
        [self.recordButton autoSetDimensionsToSize:size];
        [self.recordButton autoAlignAxis:ALAxisVertical toSameAxisOfView:_bottomHudView];
        [self.recordButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_bottomHudView withOffset:-offset];
        
        [_bottomHudView addSubview:self.nextButton];
        [self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.recordButton withOffset:10];
        [self.nextButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_bottomHudView withOffset:-offset];
        [self.nextButton autoSetDimensionsToSize:size];
    }
    return _bottomHudView;
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

- (UIButton*) flashModeButton {
    if (!_flashModeButton) {
        _flashModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashModeButton.frame = CGRectMake(CGRectGetMinX(_bottomHudView.bounds) + 15.f, 15.f, 30.0, 30.0);
        _flashModeButton.layer.masksToBounds = YES;
        _flashModeButton.imageView.contentMode = UIViewContentModeCenter;
        self.flashMode = AVCaptureFlashModeOff; //sets button image
    }
    return _flashModeButton;
}

- (UIButton*) nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _nextButton;
}

- (void) initializeViews {
    //toolbar
    [self addSubview:self.stateToolbar];
    
    //shutter view
    [self addSubview:self.shutterView];
    [self.shutterView autoCenterInSuperview];
    [self.shutterView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.shutterView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    
    //add focus view
    [self.captureView addSubview:self.focusView];
    
    //BOTTOM HUD (contains subviews)
    [self addSubview:self.bottomHudView];
    [self.bottomHudView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [self.bottomHudView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.bottomHudView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.bottomHudView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.bottomHudView autoSetDimension:ALDimensionHeight toSize:100];
    
    //TOP HUD (contains subviews)
    [self addSubview:self.topHudView];
    [self.topHudView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.topHudView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.topHudView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.topHudView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    
    //progress bar
    [self addSubview:self.progressBar];
    [self.progressBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [self.progressBar autoSetDimension:ALDimensionHeight toSize:5.0f];
    [self.progressBar autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.progressBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
}

- (void) initGestures {
    self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] init];
    self.swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeLeftGesture.delegate = self;
    [self addGestureRecognizer:self.swipeLeftGesture];
    
    self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] init];
    self.swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeRightGesture.delegate = self;
    [self addGestureRecognizer:self.swipeRightGesture];
    
    self.singleTapGesture = [[UITapGestureRecognizer alloc] init];
    self.singleTapGesture.numberOfTapsRequired = 1;
    self.singleTapGesture.delegate = self;
    [self.captureView addGestureRecognizer:self.singleTapGesture];
    
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    self.doubleTapGesture.delegate = self;
    [self addGestureRecognizer:self.doubleTapGesture];
    
    self.singleTapGesture.delaysTouchesEnded = NO;
    self.doubleTapGesture.delaysTouchesEnded = NO;
    self.swipeLeftGesture.delaysTouchesEnded = NO;
    self.swipeRightGesture.delaysTouchesEnded = NO;
    self.singleTapGesture.delaysTouchesBegan = NO;
    self.doubleTapGesture.delaysTouchesBegan = NO;
    self.swipeLeftGesture.delaysTouchesBegan = NO;
    self.swipeRightGesture.delaysTouchesBegan = NO;

    [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    @weakify(self);
    [self.swipeLeftGesture.rac_gestureSignal subscribeNext:^(UISwipeGestureRecognizer *swipeGesture) {
        @strongify(self);
        if (self.progressBar.value > 0) return;
        if (self.pageView.index + 1 <= self.pageView.labels.count-1) self.pageView.index++;
    }];
    [self.swipeRightGesture.rac_gestureSignal subscribeNext:^(UISwipeGestureRecognizer *swipeGesture) {
        @strongify(self);
        if (self.progressBar.value > 0) return;
        if (self.pageView.index - 1 >= 0) self.pageView.index--;
    }];
    [[self.singleTapGesture rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *gesture) {
        @strongify(self);
        [self updateFocusPoint:[gesture locationInView:gesture.view] alpha:1];
        [self animateFocusViewHideWithDuration:0.5 delay:0.5 completion:nil];
    }];
}

- (instancetype) initWithFrame:(CGRect)frame captureManager:(SBCaptureManager*)captureManager {
    if (self = [super initWithFrame:frame]) {
        //capture view container
        [self addSubview:self.captureViewContainer];
        self.captureView = [[SBCaptureView alloc] initWithCaptureSession:captureManager.captureSession];
        [self.captureViewContainer addSubview:self.captureView];

        [self initializeViews];
        [self setVideoCaptureType];
        
        [self initGestures];
    }
    return self;
}

- (void) adjustCameraConstraintsForRatio:(SBCameraAspectRatio)ratio captureType:(SBCaptureType)captureType{
    [self.cameraConstraints autoRemoveConstraints];
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObjectsFromArray:[self.captureView autoCenterInSuperview]];
    [constraints addObject:[self.captureView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.captureViewContainer]];

    if (ratio == SBCameraAspectRatio4_3) {
        [constraints addObject:[self.captureView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.captureViewContainer]];
    } else {
        [constraints addObject:[self.captureView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.captureViewContainer]];
    }
    
    if (captureType == SBCaptureTypeVideo) {
        [constraints addObjectsFromArray:[self.captureViewContainer autoCenterInSuperview]];
        [constraints addObject:[self.captureViewContainer autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self]];
        [constraints addObject:[self.captureViewContainer autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self]];
    } else {
        [constraints addObject:[self.captureViewContainer autoConstrainAttribute:ALEdgeTop toAttribute:ALEdgeBottom ofView:self.topHudView]];
        [constraints addObject:[self.captureViewContainer autoConstrainAttribute:ALEdgeBottom toAttribute:ALEdgeTop ofView:self.bottomHudView]];
        [constraints addObject:[self.captureViewContainer autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self]];
    }

    self.cameraConstraints = [constraints copy];
}

- (void) setFlashMode:(SBCaptureFlashMode)flashMode {
    [self willChangeValueForKey:@"flashMode"];
    _flashMode = flashMode;
    [self didChangeValueForKey:@"flashMode"];
    
    switch (flashMode) {
        case SBCaptureFlashModeOn:
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
            break;
        case SBCaptureFlashModeAuto:
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_auto"] forState:UIControlStateNormal];
            break;
        default:
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
            break;
    }
}

- (void) setPhotoCaptureTypeWithAspectRatio:(SBCameraAspectRatio)ratio {
    _aspectRatio = ratio;
    _captureType = SBCaptureTypePhoto;
    [self adjustCameraConstraintsForRatio:self.aspectRatio captureType:self.captureType];
    self.captureView.captureLayer.videoGravity = ratio == SBCameraAspectRatio1_1 ? AVLayerVideoGravityResizeAspectFill : AVLayerVideoGravityResizeAspect;
    [self layoutSubviews];
}

- (void) setVideoCaptureType {
    _aspectRatio = SBCameraAspectRatio4_3;
    _captureType = SBCaptureTypeVideo;
    [self adjustCameraConstraintsForRatio:self.aspectRatio captureType:self.captureType];
    self.captureView.captureLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self layoutSubviews];
}

- (BOOL) isHudHidden {
    return _bottomHudView.alpha == 0;
}

#pragma mark - RAC
- (RACSignal*) focusPointChangeSignal {
    @weakify(self);
    RACSignal *signal = [[RACObserve(self.focusView, frame) skip:1] map:^id(NSValue *value) {
        @strongify(self);
        CGRect frame = [value CGRectValue];
        CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        return [NSValue valueWithCGPoint:[self.captureView.captureLayer captureDevicePointOfInterestForPoint:center]];
    }];
    return signal;
}

- (RACSignal*) doubleTapSignal {
    return [self.doubleTapGesture rac_gestureSignal];
}

- (RACSignal*) swipeLeftSignal {
    return self.swipeLeftGesture.rac_gestureSignal;
}

- (RACSignal*) swipeRightSignal {
    return self.swipeRightGesture.rac_gestureSignal;
}

#pragma mark - Focus Point
- (void) didSingleTap:(CGPoint)location {
    [self updateFocusPoint:location alpha:1];
    [self animateFocusViewHideWithDuration:0.5 delay:0.5 completion:nil];
}

- (void) updateFocusPoint:(CGPoint)position alpha:(CGFloat)alpha {
    if (self.shouldUpdateFocusPosition && !self.shouldUpdateFocusPosition(position))
        return;
    
    CGRect frame = self.focusView.frame;
    frame.origin = CGPointMake(position.x-CGRectGetWidth(frame)/2, position.y-CGRectGetHeight(frame)/2);
    self.focusView.frame = frame;
    self.focusView.alpha = alpha;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !(touch.view == self.recordButton || touch.view == self.bottomHudView || touch.view == self.topHudView);
}

#pragma mark - Animations
- (void) animateHudHidden:(BOOL)hidden completion:(void (^)(BOOL))completion {
    [self animateHudHidden:hidden duration:0.5f completion:completion];
}

-(void)animateHudHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion {
    CGFloat toValue = hidden ? 0 : 1.0f;
    CGFloat bottomHudBGToValue = hidden ? 0 : .35f;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:.5 options:0 animations:^{
        NSArray *bottomViews = [_bottomHudView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", _recordButton]];
        [bottomViews setValue:@(toValue) forKey:@"alpha"];
        _bottomHudView.backgroundColor = [UIColor colorWithWhite:0 alpha:bottomHudBGToValue];
        
        _topHudView.alpha = toValue;
    } completion:^(BOOL finished) {
        if (completion) completion(finished);
    }];
}

-(void)animateShutter:(void(^)(BOOL finished))completion {
    [self animateShutterWithDuration:.1 completion:completion];
}
-(void)animateShutterWithDuration:(NSTimeInterval)duration completion:(void(^)(BOOL finished))completion {
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0 animations:^{
            self.shutterView.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:1 relativeDuration:0 animations:^{
            self.shutterView.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        if (completion) completion(finished);
    }];
}

- (void) animateFocusViewHideWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:1 initialSpringVelocity:.5 options:0 animations:^{
        self.focusView.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) completion(finished);
    }];
}

@end
