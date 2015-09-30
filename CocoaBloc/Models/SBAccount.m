//
//  SBAccount.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>

#import "SBAccount.h"
#import "MTLValueTransformer+Convenience.h"

#if TARGET_OS_IPHONE
@import UIKit.UIColor;
#else
@import AppKit.NSColor;
#endif

@implementation SBAccount

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"                  : @"id",
             @"verified"                    : @"verified",
             @"name"                        : @"name",
             @"stageblocURL"                : @"stagebloc_url",
             @"type"                        : @"type",
             @"descriptiveText"             : @"description",
             @"URL"                         : @"url",
             @"photo"                       : @"photo",
             @"stripeEnabled"               : @"stripe_enabled",
             @"color"                       : @"color",
             @"userIsAdmin"                 : @"user_is_admin",
             @"userRole"                    : @"user_role",
             @"commentSettings"             : @"user_notifications.comments",
             @"eventRSVPSettings"           : @"user_notifications.event_rsvps",
             @"generalSettings"             : @"user_notifications.general",
             @"likeSettings"                : @"user_notifications.likes",
             @"followSettings"              : @"user_notifications.follows",
             };
}

+ (MTLValueTransformer *)URLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)photoJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)commentSettingsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBNotificationSettings class]];
}

+ (MTLValueTransformer *)eventRSVPSettingsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBNotificationSettings class]];
}

+ (MTLValueTransformer *)generalSettingsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBNotificationSettings class]];
}

+ (MTLValueTransformer *)likeSettingsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBNotificationSettings class]];
}

+ (MTLValueTransformer *)followSettingsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBNotificationSettings class]];
}

+ (MTLValueTransformer *)colorJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^SBUserColor *(NSString *colorString, BOOL *success, NSError **error) {
        NSArray *colorComponents = [colorString componentsSeparatedByString:@","];
        if (colorComponents.count < 3) {
            *success = NO;
#warning set error once we have a domain
            return nil;
        }
        *success = YES;
        
        return [SBUserColor colorWithRed:([colorComponents[0] floatValue] / 255)
                                   green:([colorComponents[1] floatValue] / 255)
                                    blue:([colorComponents[2] floatValue] / 255)
                                   alpha:1];
    } reverseBlock:^NSString *(SBUserColor *color, BOOL *success, NSError **error) {
        *success = YES;
        
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        r *= 255;
        b *= 255;
        g *= 255;
        
        return [NSString stringWithFormat:@"%d,%d,%d", (int)r, (int)g, (int)b];
    }];
}

@end

