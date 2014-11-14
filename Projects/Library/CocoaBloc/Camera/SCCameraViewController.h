//
//  SCCameraViewController.h
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCaptureManager.h"

@class SCCameraViewController;

@protocol SCCameraViewControllerDelegate <NSObject>
@optional
/* 
 * Called when user presses the close button
 * Should dismiss or pop controller in this delegate.
 */
- (void) cameraViewControllerDidFinish:(SCCameraViewController*)controller;
@end

@interface SCCameraViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SCCameraViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
