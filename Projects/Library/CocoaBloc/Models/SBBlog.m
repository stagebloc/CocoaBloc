//
//  SBBlog.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBBlog.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"

@implementation SBBlog

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"relatedContentTag" 	: @"related_content_tag",
			  @"body" 				: @"body",
			  @"category" 			: @"category",
              @"photo"              : @"photo"}];
}

+ (MTLValueTransformer *)photoJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBPhoto class]];
}

@end
