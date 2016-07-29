//
//  SBAccount.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBAccount.h"
#import "MTLValueTransformer+CocoaBloc.h"

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
	return [MTLValueTransformer reversibleUserColorTransformer];
}

@end

