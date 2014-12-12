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

@interface SBCaptureViewController : UIViewController <UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
