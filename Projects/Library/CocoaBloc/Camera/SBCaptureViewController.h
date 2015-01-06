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
 Set this delegate to handle dismissals and when an SBAsset is accepted by the user.
 */
@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
