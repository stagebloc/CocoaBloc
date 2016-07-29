//
//  SBModifiableContent.m
//  CocoaBloc
//
//  Created by Dan Zimmerman on 2/29/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

#import "SBModifiableContent.h"

#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBModifiableContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{
			  @"modificationDate"       : @"modified",
			  @"creationDate"           : @"created",
			  @"isExclusive"            : @"exclusive"
			  }];
}

+ (NSValueTransformer *)modificationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (NSValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

- (NSDate *)initialDate {
	return _creationDate;
}

@end
