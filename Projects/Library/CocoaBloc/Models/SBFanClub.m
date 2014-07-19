//
//  SBFanClub.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBFanClub.h"

@implementation SBFanClub

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"title" 				: @"title",
			  @"descriptiveText" 	: @"moderation_queue",
			  @"userTier" 			: @"user_tier",
			  @"canPostStatuses" 	: @"allowed_content_sections.statuses",
			  @"canPostPhotos" 		: @"allowed_content_sections.photos",
			  @"canPostBlogs" 		: @"allowed_content_sections.blog"}];
}

@end
