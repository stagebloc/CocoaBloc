//
//  SCImagePickerController.m
//  StitchCam
//
//  Created by David Skuza on 10/22/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBImagePickerController.h"

@implementation SBImagePickerController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (!self.completionBlock)
        return;
    self.completionBlock(image, editingInfo);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (!self.completionBlock)
        return;
    
    UIImage *possibleImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (possibleImage)
        self.completionBlock(possibleImage, info);
    
    self.completionBlock(nil, info);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (!self.completionBlock)
        return;
    self.completionBlock(nil, nil);
}

@end
