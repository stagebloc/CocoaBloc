//
//  SBUser.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBUser.h"

@implementation SBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"			: @"id",
             @"birthdateString"		: @"birthday",
             @"name" 				: @"name",
             @"URL"					: @"url",
             @"bio"					: @"bio",
             @"color"				: @"color",
             @"username"			: @"username",
             @"createdDateString" 	: @"created"};
}

@end
