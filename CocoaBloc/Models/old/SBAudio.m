//
//  SBAudioUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBAudio.h"
#import "MTLValueTransformer+CocoaBloc.h"

@implementation SBAudio

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"editURL" :		@"edit_url",
			  @"streamURL":		@"stream_url",
			  @"artist":		@"artist",
			  @"isSticky":		@"sticky",
			  @"lyrics":		@"lyrics"}];
}

+ (MTLValueTransformer *)editURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)streamURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
