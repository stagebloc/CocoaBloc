//
//  SCReviewController.h
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SCReviewController;

@protocol SCReviewControllerDelegate <NSObject>
@optional
- (void) reviewController:(SCReviewController*)controller acceptedImage:(UIImage*)image;
- (void) reviewController:(SCReviewController*)controller rejectedImage:(UIImage*)image;
@end

@interface SCReviewController : UIViewController

@property (strong, nonatomic) UIImage *image;

@property (nonatomic, weak) id <SCReviewControllerDelegate> delegate;

- (instancetype) initWithImage:(UIImage*)image;

@end
