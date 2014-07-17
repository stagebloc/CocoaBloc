//
//  SBAccount.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAccount.h"

@implementation SBAccount

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"	: @"id",
             @"verified"	: @"verified",
             @"name"	 	: @"name",
             @"stageblocURL": @"stagebloc_url",
             @"type"		: @"type",
             @"URL"			: @"url"};
}

@end
