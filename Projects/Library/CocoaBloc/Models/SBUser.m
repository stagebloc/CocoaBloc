//
//  SBUser.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBUser.h"
#import "MTLValueTransformer+Convenience.h"
#import "NSDateFormatter+CocoaBloc.h"

#if TARGET_OS_IPHONE
@import UIKit.UIColor;
#else
@import AppKit.NSColor;
#endif

@implementation SBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"			: @"id",
             @"birthday"			: @"birthday",
             @"name" 				: @"name",
             @"URL"					: @"url",
             @"bio"					: @"bio",
             @"gender"				: @"gender",
             @"emailAddress"		: @"email",
             @"color"				: @"color",
             @"username"			: @"username",
             @"creationDate"	 	: @"created",
             @"photo"				: @"photo",
			 @"adminAccounts"		: NSNull.null};
}

+ (MTLValueTransformer *)photoJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformer];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)birthdayJSONTransformer {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:formatter];
}

+ (MTLValueTransformer *)URLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)colorJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^SBUserColor *(NSString *colorString) {
    	NSArray *colorComponents = [colorString componentsSeparatedByString:@","];
        NSAssert(colorComponents.count >= 3, @"API returned a color string of an unknown format");
        
    	return [SBUserColor colorWithRed:([colorComponents[0] floatValue] / 255)
                                   green:([colorComponents[1] floatValue] / 255)
                                    blue:([colorComponents[2] floatValue] / 255)
                                   alpha:1];
    } reverseBlock:^NSString *(SBUserColor *color) {
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        r *= 255;
        b *= 255;
        g *= 255;
        
        return [NSString stringWithFormat:@"%d,%d,%d", (int)r, (int)g, (int)b];
    }];
}

@end
