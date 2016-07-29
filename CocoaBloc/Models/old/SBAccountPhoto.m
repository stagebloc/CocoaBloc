//
//  SBPhoto.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBAccountPhoto.h"
#import "SBAccount.h"
#import "MTLValueTransformer+CocoaBloc.h"

@implementation SBAccountPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"width"				: @"width",
			  @"height"				: @"height",
			  @"originalURL"		: @"images.original_url",
			  @"smallURL"			: @"images.small_url",
			  @"mediumURL"			: @"images.medium_url",
			  @"largeURL"			: @"images.large_url",
			  @"thumbnailURL"		: @"images.thumbnail_url",
			  @"isSticky"			: @"sticky",
			  @"descriptiveText"	: @"description"
			  }];
}

+ (MTLValueTransformer *)thumbnailURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)smallURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)mediumURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)largeURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)originalURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
