//
//  UIImage+Resize.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizeImageToRect:(CGRect)rect;
{
    if (UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
