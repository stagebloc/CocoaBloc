//
//  SBFanClub.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBFanClub.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import "SBTier.h"

@implementation SBFanClub

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"accountID"           : @"account",
			 @"title" 				: @"title",
			 @"descriptiveText" 	: @"description",
			 @"userTier" 			: @"user_tier",
			 @"canPostStatuses" 	: @"allowed_content_sections.statuses",
			 @"canPostPhotos" 		: @"allowed_content_sections.photos",
			 @"canPostBlogs" 		: @"allowed_content_sections.blog",
			 @"canPostVideos" 		: @"allowed_content_sections.videos",
			 @"canPostAudio" 		: @"allowed_content_sections.audio",
			 @"moderated"           : @"moderation_queue",
			 @"tierOne"             : @"tier_info.1",
			 @"tierTwo"             : @"tier_info.2",
			 @"tierThree"           : @"tier_info.3",
			 @"account"             : @"account",
			 };
}

+ (MTLValueTransformer *)tierOneJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)tierTwoJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)tierThreeJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)accountIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)accountJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
