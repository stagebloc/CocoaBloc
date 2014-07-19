//
//  SBBlog.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBBlog.h"

@implementation SBBlog

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"dateModified" 		: @"modified",
			  @"sticky" 			: @"sticky",
			  @"exclusive" 			: @"exclusive",
			  @"relatedContentTag" 	: @"related_content_tag",
			  @"body" 				: @"body",
			  @"category" 			: @"category"}];
}

@end
