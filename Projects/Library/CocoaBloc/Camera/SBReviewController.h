//
//  SCReviewController.h
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SBReviewController;

@protocol SBReviewControllerDelegate <NSObject>
@optional
- (void) reviewController:(SBReviewController*)controller acceptedImage:(UIImage*)image title:(NSString*)title description:(NSString*)description;
- (void) reviewController:(SBReviewController*)controller rejectedImage:(UIImage*)image;
@end

@interface SBReviewController : UIViewController

@property (strong, nonatomic) UIImage *image;

@property (nonatomic, weak) id <SBReviewControllerDelegate> delegate;

- (instancetype) initWithImage:(UIImage*)image;

@end
