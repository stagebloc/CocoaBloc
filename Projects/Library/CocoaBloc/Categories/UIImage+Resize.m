//
//  UIImage+Resize.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*) resizeToSquare {
    CGRect rect;
    if (self.size.width < self.size.height) {
        rect = CGRectMake(0, (self.size.height-self.size.width)/2, self.size.width, self.size.width);
    } else {
        rect = CGRectMake((self.size.width-self.size.height)/2, 0, self.size.height, self.size.height);
    }
    return [self resizeImageToRect:rect];
}

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
