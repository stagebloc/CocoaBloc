//
//  SCCameraViewController.h
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCaptureManager.h"

@class SBCameraViewController;

@protocol SBCameraViewControllerDelegate <NSObject>
@optional
/* 
 * Called when user presses the close button
 * Should dismiss or pop controller in this delegate.
 */
- (void) cameraViewControllerDidFinish:(SBCameraViewController*)controller;
@end

@interface SBCameraViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SBCameraViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
