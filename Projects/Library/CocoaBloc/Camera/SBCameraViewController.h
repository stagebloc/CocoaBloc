//
//  SBCameraViewController.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/1/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBReviewView.h"
#import "SBCaptureViewController.h"

/*!
 This class is responsible for controlling the flow of the camera module. This class should be instantiated in favor of the other camera controllers (exception would be `SBReviewController`).
 
 Note that this class is a subclass of `UINavigationController`
 */
@interface SBCameraViewController : UINavigationController

/*!
 Set this delegate to handle dismissals and when an SBAsset is accepted by the user.
 */
@property (nonatomic, weak) id<SBCaptureViewControllerDelegate> captureDelegate;

/*!
 Sets the review step options
 Sets initial capture type to SBCaptureTypeVideo
 Sets the DEFAULT allowed capture types = SBCaptureTypePhoto | SBCaptureTypeVideo
 */
- (instancetype) initWithReviewOptions:(SBReviewViewOptions)options;

/*!
 Sets the review step options and
 Sets initial capture type to start with for the controller
 Sets the DEFAULT allowed capture types = SBCaptureTypePhoto | SBCaptureTypeVideo
 */
- (instancetype) initWithReviewOptions:(SBReviewViewOptions)options initialCaptureType:(SBCaptureType)captureType;

/*!
 Sets the review step options and
 Sets initial capture type to start with for the controller
 Sets the allowed capture types for controller.
 
 NOTE: initialCaptureType depends on allowedCaptureTypes. If an initialCaptureType
 is set that isn't supported in allowedCaptureTypes, then the initialCaptureType will
 be overridden.
 */
- (instancetype)initWithReviewOptions:(SBReviewViewOptions)options
                   initialCaptureType:(SBCaptureType)captureType
                  allowedCaptureTypes:(SBCaptureType)allowedCaptureTypes;

@end
