//
//  SBAudioUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAudio.h"
#import "MTLValueTransformer+CocoaBloc.h"

@implementation SBAudio

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"editURL" :      @"edit_url",
              @"streamURL":     @"stream_url",
              @"artist":        @"atrist",
              @"lyrics":        @"lyrics"}];
}

+ (MTLValueTransformer *)editURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
