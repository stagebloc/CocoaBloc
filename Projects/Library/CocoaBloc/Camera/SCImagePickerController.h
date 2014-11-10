//
//  SCImagePickerController.h
//  StitchCam
//
//  Created by David Skuza on 10/22/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCImagePickerController : UIImagePickerController <UIImagePickerControllerDelegate>

@property (nonatomic, copy) void (^completionBlock)(UIImage *image, NSDictionary *info);

@end
