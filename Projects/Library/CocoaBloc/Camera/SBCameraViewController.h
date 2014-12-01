//
//  SCCameraViewController.h
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCaptureManager.h"

@class SBCameraViewController, SBAsset;

@protocol SBCameraViewControllerDelegate <NSObject>
@optional
- (void) cameraController:(SBCameraViewController*)controller acceptedAsset:(SBAsset*)asset;
- (void) cameraControllerCancelled:(SBCameraViewController*)controller;
@end

@interface SBCameraViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SBCameraViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;


@end
