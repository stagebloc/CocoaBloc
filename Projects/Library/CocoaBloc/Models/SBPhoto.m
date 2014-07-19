//
//  SBPhoto.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBPhoto.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>

@implementation SBPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"descriptiveText" : @"description",
			  @"width" : @"width",
			  }];
}

@end
