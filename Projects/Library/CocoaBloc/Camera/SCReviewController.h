//
//  SCReviewController.h
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SCReviewController : UIViewController

@property (strong, nonatomic) UIImage *image;

- (instancetype) initWithImage:(UIImage*)image;

@end
