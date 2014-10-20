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
            @{@"dateOrdered"	: @"ordered",
              @"dateShipped"    : @"shipped",
              @"email"          : @"email",
              @"customer"       : @"user",
              @"account"        : @"account",
              @"address"        : @"address",
              @"stripeChargeId" : @"stripe_charge_id",
              @"totalUsd"       : @"total_usd"}];
}

+ (MTLValueTransformer *)userJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id userValue) {
        return [MTLJSONAdapter modelOfClass:[SBUser class]
                         fromJSONDictionary:userValue
                                      error:nil];
    } reverseBlock:^id(id userValue) {
        return [MTLJSONAdapter JSONArrayFromModels:userValue];
    }];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id accountValue) {
        return [MTLJSONAdapter modelOfClass:[SBAccount class]
                         fromJSONDictionary:accountValue
                                      error:nil];
    } reverseBlock:^id(id accountValue) {
        return [MTLJSONAdapter JSONArrayFromModels:accountValue];
    }];
}

+ (MTLValueTransformer *)addressJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id addressValue) {
        return [MTLJSONAdapter modelOfClass:[SBAddress class]
                             fromJSONDictionary:addressValue
                                          error:nil];
    } reverseBlock:^id(id addressValue) {
        return [MTLJSONAdapter JSONArrayFromModels:addressValue];
    }];
}

+ (MTLValueTransformer *)dateOrderedJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)dateShippedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id dateShippedValue) {
        if ([dateShippedValue isKindOfClass:[NSNumber class]]) {
            return nil;
        } else {
            return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
        }
    } reverseBlock:^id(id dateShippedValue) {
        return [MTLJSONAdapter JSONArrayFromModels:dateShippedValue];
    }];
}

@end
