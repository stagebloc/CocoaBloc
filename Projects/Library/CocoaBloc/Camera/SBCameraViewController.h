//
//  SBCameraViewController.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/1/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCaptureViewController.h"

@interface SBCameraViewController : UINavigationController

@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> captureDelegate;

/*
 Sets initial capture type to start with for the controller
 Default (from `init` method) is SBCaptureTypeVideo
 */
- (instancetype) initWithCaptureType:(SBCaptureType)captureType;

@end
