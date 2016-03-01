//
//  SBContent.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

#import "SBPhoto.h"
#import "SBBlog.h"
#import "SBStatus.h"
#import "SBVideo.h"
#import "SBAudio.h"

#import "SBUser.h"
#import "SBAccount.h"

@implementation SBContent

+ (NSString *)URLPathContentType {
	static NSDictionary *classToContentURLContentTypes = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		classToContentURLContentTypes = @{NSStringFromClass([SBPhoto class])   : @"photo",
										  NSStringFromClass([SBBlog class])    : @"blog",
										  NSStringFromClass([SBStatus class])  : @"status",
										  NSStringFromClass([SBVideo class])   : @"video",
										  NSStringFromClass([SBAudio class])   : @"audio"};
	});
	
	return classToContentURLContentTypes[NSStringFromClass(self)];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{
			  @"title"                  : @"title",
			  @"inModeration"           : @"in_moderation",
			  @"isFanContent"           : @"is_fan_content",
			  @"userHasLiked"           : @"user_has_liked",
			  @"likeCount"              : @"like_count",
			  @"commentCount"           : @"comment_count",
			  @"shortURL"               : @"short_url",
			  @"accountID"              : @"account",
			  @"account"                : @"account",
			  @"authorUser"             : @"user",
			  @"authorUserID"           : @"user"}
			];
}


+ (MTLValueTransformer *)shortURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)accountIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)accountJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
