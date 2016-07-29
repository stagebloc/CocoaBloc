//
//  SBBlog.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBBlog.h"

#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBBlog

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"body" 				: @"body",
			  @"strippedBody"		: @"body_stripped",
			  @"category" 			: @"category",
			  @"isSticky"			: @"sticky",
			  @"publishDate"		: @"published"}];
}

+ (NSValueTransformer *)publishDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

@end
