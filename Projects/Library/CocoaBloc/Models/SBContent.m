//
//  SBContent.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"

@implementation SBContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"commentCount" 	: @"comment_count",
			  @"creationDate" 	: @"created",
			  @"excerpt"		: @"excerpt",
			  @"inModeration"	: @"in_moderation",
			  @"likeCount"		: @"like_count",
			  @"publishDate"	: @"published",
			  @"shortURL"		: @"short_url",
			  @"title"			: @"title",
			  @"userHasLiked"	: @"user_has_liked" }];
}

@end
