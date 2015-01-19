//
//  SBTier.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/15/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBTier.h"

@implementation SBTier

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"canSubmitContent"    : @"can_submit_content",
             @"title" 				: @"title",
             @"descriptiveText" 	: @"description",
             @"discount" 			: @"discount",
             @"membershipLength" 	: @"membership_length",
             @"price"               : @"price",
             @"renewalPrice" 		: @"renewal_price",
             };
}

@end
