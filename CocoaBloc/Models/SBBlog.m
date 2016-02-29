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
			@{@"body" 				: @"body",
			  @"strippedBody"		: @"body_stripped",
			  @"category" 			: @"category"}];
}

@end
