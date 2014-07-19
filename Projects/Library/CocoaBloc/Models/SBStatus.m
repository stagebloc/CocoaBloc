//
//  SBStatus.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBStatus.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>

@implementation SBStatus

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"text" : @"text"}];
}

@end
