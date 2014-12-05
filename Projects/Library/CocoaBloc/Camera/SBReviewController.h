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

@interface SBReviewController : UIViewController

@property (nonatomic, strong, readonly) SBAsset *asset;
@property (nonatomic, weak) id <SBReviewControllerDelegate> delegate;

- (instancetype) initWithAsset:(SBAsset*)asset;

@end
