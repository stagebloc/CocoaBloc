//
//  SBAccount.m
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAccount.h"
#import <Mantle/Mantle.h>
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"
#import <RACCommand.h>

@implementation SBAccount

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"	  : @"id",
             @"verified"	  : @"verified",
             @"name"	 	  : @"name",
             @"stageblocURL"  : @"stagebloc_url",
             @"type"		  : @"type",
             @"URL"			  : @"url",
             @"photo"         : @"photo",
             @"stripeEnabled" : @"stripe_enabled",
             @"userIsAdmin"   : @"user_is_admin",
             };
}

+ (MTLValueTransformer *)photoJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
