//
//  UIFont+FanClub.m
//  Fan Club
//
//  Created by David Skuza on 4/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIFont+FanClub.h"

@implementation UIFont (FanClub)

+ (UIFont *)fc_fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)fc_mediumFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)fc_boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+ (UIFont *)fc_lightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

@end
