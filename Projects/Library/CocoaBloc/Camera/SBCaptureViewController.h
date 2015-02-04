//
//  SCCameraViewController.h
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCaptureManager.h"
#import "SBReviewController.h"

@class SBCaptureViewController, SBAsset;

@protocol SBCaptureViewControllerDelegate <SBReviewControllerDelegate>
@optional
- (void) cameraControllerCancelled:(SBCaptureViewController*)controller;
@end

/*!
 This class is responsible for controlling and utilizing the camera to output an `SBAsset` to the `SBReviewController`.
 See `SBCameraViewController` as it is preferred to be used & instantiated than manually instantiating this controller.
 */
@interface SBCaptureViewController : UIViewController <UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate>

/*!
 This is responsible for handling how the options menu in the review step
 of the camera module is shown. These options will be passed to the SBReviewController.
 
 SBReviewViewOptionsDoNotShow = Hides the options menu all together.
 SBReviewViewOptionsShowOfficialButton = Only shows the official option button,
 SBReviewViewOptionsShowExclusiveButton = Only shows the exclusive option button,
 SBReviewViewOptionsShowOfficialButton | SBReviewViewOptionsShowExclusiveButton = Shows both buttons in the options menu.
 
 DEFAULT is SBReviewViewOptionsDoNotShow
 */
@property (nonatomic, assign) SBReviewViewOptions reviewOptions;

/*!
 The allowed capture types. 
 The DEFAULT is both video and photo capture types (SBCaptureTypePhoto | SBCaptureTypeVideo).
 Set this property via `initWithCaptureType:allowedCaptureTypes:`
 */
@property (nonatomic, readonly) SBCaptureType allowedCaptureTypes;


/*!
 Set this delegate to handle dismissals and when an SBAsset is accepted by the user.
 */
@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype)initWithInitialCaptureType:(SBCaptureType)captureType;

/*
 Sets initial capture type to start with for the controller
 and the allowed capture types.
 
 NOTE: initialCaptureType depends on allowedCaptureTypes. If an initialCaptureType
 is set that isn't supported in allowedCaptureTypes, then the initialCaptureType will
 be overridden.
 */
- (instancetype)initWithInitialCaptureType:(SBCaptureType)captureType allowedCaptureTypes:(SBCaptureType)allowedCaptureTypes;

@end
