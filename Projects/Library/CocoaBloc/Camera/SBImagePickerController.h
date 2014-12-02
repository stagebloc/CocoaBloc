//
//  SCImagePickerController.h
//  StitchCam
//
//  Created by David Skuza on 10/22/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SBImagePickerController : UIImagePickerController

- (RACSignal*) imageSelectSignal;

@end
