//
//  SCReviewController.h
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SBReviewController, SBAsset;

@protocol SBReviewControllerDelegate <NSObject>
@optional
- (void) reviewController:(SBReviewController*)controller acceptedAsset:(SBAsset*)asset;
- (void) reviewController:(SBReviewController*)controller rejectedAsset:(SBAsset*)asset;
@end

/*!
 This class is responsible for manipulating an `SBAsset`. Once the user has reviewed the `asset`, the user may reject or accept the `asset` which should be handled by the `delegate`.
 You may desire to show this controller with an asset rather than having to go through the entire `SBCameraViewController` stack again.
 */
@interface SBReviewController : UIViewController

/*! 
 The asset the controller will be presenting to the user to manipulate. */
@property (nonatomic, strong, readonly) SBAsset *asset;

/*!
 This delegate will be responsibile to handling rejections and acceptions of the `asset`. */
@property (nonatomic, weak) id <SBReviewControllerDelegate> delegate;

/*!
 This init method is required in order to utilize this class*/
- (instancetype) initWithAsset:(SBAsset*)asset;

@end
