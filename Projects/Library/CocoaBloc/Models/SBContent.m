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

+ (MTLValueTransformer *)shortURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (NSValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[self JSONDateFormatter]];
}

+ (NSDateFormatter *)JSONDateFormatter {
    NSDateFormatter *df = [NSDateFormatter new];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"EN_US_POSIX"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
	return df;
}

@end
