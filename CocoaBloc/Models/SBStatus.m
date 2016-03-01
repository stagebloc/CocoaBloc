//
//  SBStatus.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBStatus.h"

#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBStatus

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"text"			: @"text",
			  @"publishDate"	: @"published"}];
}

+ (NSValueTransformer *)publishDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

@end
