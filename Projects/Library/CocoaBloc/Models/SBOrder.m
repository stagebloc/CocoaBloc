//
//  SBOrder.m
//  Pods
//
//  Created by Josh Holat on 10/17/14.
//
//

#import "SBOrder.h"
#import "SBUser.h"
#import "SBAccount.h"
#import "SBAddress.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBOrder

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"dateOrdered"                : @"ordered",
              @"dateShipped"                : @"shipped",
              @"email"                      : @"email",
              @"customerOrCustomerUserID"   : @"user",
              @"accountOrAccountID"         : @"account",
              @"address"                    : @"address",
              @"stripeChargeId"             : @"stripe_charge_id",
              @"totalUsd"                   : @"total_usd"}];
}

+ (MTLValueTransformer *)customerOrCustomerUserIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBUser class]];
}

+ (MTLValueTransformer *)accountOrAccountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBAccount class]];
}

+ (MTLValueTransformer *)addressJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBAddress class]];
}

+ (MTLValueTransformer *)dateOrderedJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)dateShippedJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

@end
