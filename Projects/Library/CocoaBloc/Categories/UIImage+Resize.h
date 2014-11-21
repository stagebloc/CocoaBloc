//
//  UIImage+Resize.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage*) resizeToSquare;
- (UIImage *)resizeImageToRect:(CGRect)rect;

@end
