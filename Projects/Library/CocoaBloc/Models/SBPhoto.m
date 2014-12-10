//
//  SBPhoto.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBPhoto.h"
#import "SBAccount.h"
#import "MTLValueTransformer+Convenience.h"

#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import <Mantle/MTLValueTransformer.h>

@implementation SBPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"width" 			: @"width",
              @"height"			: @"height",
              @"originalURL" 	: @"images.original_url",
              @"smallURL" 		: @"images.small_url",
              @"mediumURL"		: @"images.medium_url",
              @"largeURL"		: @"images.large_url",
              @"thumbnailURL"	: @"images.thumbnail_url"}];
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
