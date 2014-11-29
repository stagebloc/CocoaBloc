//
//  SCImagePickerController.m
//  StitchCam
//
//  Created by David Skuza on 10/22/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBImagePickerController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation SBImagePickerController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
}

- (RACSignal*) imageSelectSignal {
    return [[self rac_imageSelectedSignal] map:^id(NSDictionary *userInfo) {
        if ([userInfo isKindOfClass:[NSDictionary class]])
            return [userInfo objectForKey:UIImagePickerControllerOriginalImage];
        return userInfo;
    }];
}

@end
