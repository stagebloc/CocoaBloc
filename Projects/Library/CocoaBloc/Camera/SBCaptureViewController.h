//
//  SCCameraViewController.h
//  StitchCam
//
//  Created by David Skuza on 8/29/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCaptureManager.h"

@class SBCaptureViewController, SBAsset;

@protocol SBCaptureViewControllerDelegate <NSObject>
@optional
- (void) cameraController:(SBCaptureViewController*)controller acceptedAsset:(SBAsset*)asset;
- (void) cameraControllerCancelled:(SBCaptureViewController*)controller;
@end

@interface SBCaptureViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> delegate;

/*
 Sets initial capture type to start with for the controller
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
