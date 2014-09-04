//
//  UIColor+FanClub.m
//  Fan Club
//
//  Created by David Skuza on 4/25/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIColor+FanClub.h"

@implementation UIColor (FanClub)

+ (UIColor *)fc_stageblocBlueColor
{
    return [self fc_colorFromHex:0x46aaff];
}

+ (UIColor *)fc_pinkColor
{
    return [self fc_colorFromHex:0xff2d55];
}

+ (UIColor *)fc_yellowColor
{
    return [self fc_colorFromHex:0xffde47];
}

+ (UIColor *)fc_redColor
{
    return [self fc_colorFromHex:0xff7364];
}

+ (UIColor *)fc_greenColor
{
    return [self fc_colorFromHex:0x71e771];
}

+ (UIColor *)fc_darkTextColor
{
    return [self fc_colorFromHex:0x525556];
}

+ (UIColor *)fc_lightTextColor
{
    return [self fc_colorFromHex:0xacb2b8];
}

+ (UIColor *)fc_lightBackgroundColor
{
    return [self fc_colorFromHex:0xe5e5e5];
}

+ (UIColor *)fc_lightHRColor
{
    return [self fc_colorFromHex:0xd8d8d8];
}

+ (UIColor *)fc_colorFromHex:(NSInteger)hex
{
    CGFloat r = ((hex >> 16) & 0xff) / 255.f;
    CGFloat g = ((hex >> 8) & 0xff) / 255.f;
    CGFloat b = (hex & 0xff) / 255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

@end
