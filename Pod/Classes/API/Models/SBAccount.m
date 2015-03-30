//
//  SBAccount.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAccount.h"
#import <Mantle/Mantle.h>
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"
#import <RACCommand.h>

@implementation SBAccount

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"                  : @"id",
             @"verified"                    : @"verified",
             @"name"                        : @"name",
             @"stageblocURL"                : @"stagebloc_url",
             @"type"                        : @"type",
             @"URL"                         : @"url",
             @"photo"                       : @"photo",
             @"stripeEnabled"               : @"stripe_enabled",
             @"userIsAdmin"                 : @"user_is_admin",
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

@end

