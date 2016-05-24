//
//  SBContentStreamObject.m
//  CocoaBloc
//
//  Created by Dan Zimmerman on 3/2/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBContentStreamObject.h"

#import "MTLValueTransformer+CocoaBloc.h"

@implementation SBContentStreamObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{
			 @"title":				@"title",
			 @"shortURL":			@"short_url",
			 @"commentCount":		@"comment_count",
			 @"likeCount":			@"like_count",
			 @"accountID":			@"account",
			 @"account":			@"account",
			 @"userHasLiked":		@"user_has_liked"
			 }];
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

- (NSDate *)initialDate {
	return nil;
}

@end
