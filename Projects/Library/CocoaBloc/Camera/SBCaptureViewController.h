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
 Set this delegate to handle dismissals and when an SBAsset is accepted by the user.
 */
@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> delegate;

/*!Whether or not the user enabled the `official` button*/
@property (nonatomic, assign, readonly) BOOL isOfficialEnabled;

/*!Whether or not the user enabled the `exclusive` button*/
@property (nonatomic, assign, readonly) BOOL isExclusiveEnabled;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
