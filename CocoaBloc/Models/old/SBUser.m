//
//  SBUser.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBUser.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"identifier"			: @"id",
			 @"birthday"			: @"birthday",
			 @"name" 				: @"name",
			 @"URL"					: @"url",
			 @"bio"					: @"bio",
			 @"gender"				: @"gender",
			 @"emailAddress"		: @"email",
			 @"color"				: @"color",
			 @"username"			: @"username",
			 @"creationDate"	 	: @"created",
			 @"photo"				: @"photo"};
}

+ (MTLValueTransformer *)photoJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)birthdayJSONTransformer {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:formatter];
}

+ (MTLValueTransformer *)URLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)colorJSONTransformer {
	return [MTLValueTransformer reversibleUserColorTransformer];
}

@end
