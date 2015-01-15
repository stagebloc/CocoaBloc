//
//  SBFanClub.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBFanClub.h"
#import <Mantle/Mantle.h>
#import "MTLValueTransformer+Convenience.h"
#import "SBTier.h"

@implementation SBFanClub

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"          : @"account",
             @"title" 				: @"title",
             @"descriptiveText" 	: @"description",
             @"userTier" 			: @"user_tier",
             @"canPostStatuses" 	: @"allowed_content_sections.statuses",
             @"canPostPhotos" 		: @"allowed_content_sections.photos",
             @"canPostBlogs" 		: @"allowed_content_sections.blog",
             @"canPostVideos" 		: @"allowed_content_sections.videos",
             @"canPostAudio" 		: @"allowed_content_sections.audio",
             @"moderated"           : @"moderation_queue",
             @"tierOne"              : @"tier_info.1",
             @"tierTwo"              : @"tier_info.2",
             @"tierThree"            : @"tier_info.3",
             };
}

+ (NSValueTransformer*) tierOneJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBTier class]];
}
+ (NSValueTransformer*) tierTwoJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBTier class]];
}
+ (NSValueTransformer*) tierThreeJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBTier class]];
}

@end
