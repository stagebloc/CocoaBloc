//
//  SCCameraViewController.h
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCProgressBar.h"
#import "SCRecordButton.h"
#import "SCCaptureManager.h"

@class SCCameraViewController;

@protocol SCCameraViewControllerDelegate <NSObject>
@optional
/* 
 * Called when user presses the close button
 * Should dismiss or pop controller in this delegate.
 */
- (void) cameraViewControllerDidFinish:(SCCameraViewController*)controller;
@end

@interface SCCameraViewController : UIViewController <SCProgressBarDelegate, SCRecordButtonDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SCCameraViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (id) initWithCaptureType:(SCCaptureType)captureType;

- (SCCaptureType) currentCaptureType;

@end
