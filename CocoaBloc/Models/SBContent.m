//
//  SBContent.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

#import "SBPhoto.h"
#import "SBBlog.h"
#import "SBStatus.h"
#import "SBVideo.h"
#import "SBAudio.h"

#import "SBUser.h"
#import "SBAccount.h"

@implementation SBContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{
			  @"inModeration"           : @"in_moderation",
			  @"isFanContent"           : @"is_fan_content",
			  @"authorUser"             : @"user",
			  @"authorUserID"           : @"user"
			}];
}


+ (MTLValueTransformer *)authorUserIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
