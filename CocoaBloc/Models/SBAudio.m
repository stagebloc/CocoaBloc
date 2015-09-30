//
//  SBAudioUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAudio.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import <Mantle/Mantle.h>

@implementation SBAudio

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"editURL" : @"edit_url"}];
}

+ (MTLValueTransformer *)editURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
