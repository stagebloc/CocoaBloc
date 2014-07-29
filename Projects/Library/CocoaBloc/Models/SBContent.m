//
//  SBContent.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "MTLValueTransformer+Convenience.h"
#import "NSDateFormatter+CocoaBloc.h"
#import <Mantle/Mantle.h>

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

+ (MTLValueTransformer *)shortURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (NSValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (NSValueTransformer *)publishDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}



@end
