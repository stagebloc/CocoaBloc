//
//  UIColor+CocoaBloc.h
//  Fan Club
//
//  Created by David Skuza on 4/25/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CocoaBloc)

+ (UIColor *)fc_stageblocBlueColor;

+ (UIColor *)fc_pinkColor;
+ (UIColor *)fc_darkPinkColor;
+ (UIColor *)fc_yellowColor;
+ (UIColor *)fc_redColor;
+ (UIColor *)fc_greenColor;

+ (UIColor *)fc_darkTextColor;
+ (UIColor *)fc_lightTextColor;

+ (UIColor *)fc_lightBackgroundColor;
+ (UIColor *)fc_lightHRColor;

+ (UIColor *)fc_colorFromHex:(NSInteger)hex;

@end
