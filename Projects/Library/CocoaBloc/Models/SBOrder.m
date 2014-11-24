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

+ (MTLValueTransformer *)customerJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id customerValue) {
        if ([customerValue isKindOfClass:[NSNumber class]]) { // unexpanded
            return customerValue;
        }
        // else it's the json for the user
        return [MTLJSONAdapter modelOfClass:[SBUser class]
                         fromJSONDictionary:customerValue
                                      error:nil];
    } reverseBlock:^id(id customerModelValue) {
        if ([customerModelValue isKindOfClass:[NSNumber class]]) {
            return customerModelValue;
        }
        return [MTLJSONAdapter JSONDictionaryFromModel:customerModelValue];
    }];
}

+ (MTLValueTransformer *)userJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id userValue) {
        if ([userValue isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:[SBUser class]
                             fromJSONDictionary:userValue
                                          error:nil];
        }
        return userValue;
    } reverseBlock:^id(id userValue) {
        if ([userValue isKindOfClass:[SBUser class]]) {
            return [MTLJSONAdapter JSONDictionaryFromModel:userValue];
        }
        return userValue;
    }];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id accountValue) {
        if ([accountValue isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:[SBAccount class]
                             fromJSONDictionary:accountValue
                                          error:nil];
        }
        return accountValue;
    } reverseBlock:^id(id accountValue) {
        if ([accountValue isKindOfClass:[SBAccount class]]) {
            return [MTLJSONAdapter JSONDictionaryFromModel:accountValue];
        }
        return accountValue;
    }];
}

+ (MTLValueTransformer *)addressJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id addressValue) {
        return [MTLJSONAdapter modelOfClass:[SBAddress class]
                             fromJSONDictionary:addressValue
                                          error:nil];
    } reverseBlock:^id(id addressValue) {
        return [MTLJSONAdapter JSONDictionaryFromModel:addressValue];
    }];
}

+ (MTLValueTransformer *)dateOrderedJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)dateShippedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id dateShippedValue) {
        if ([dateShippedValue isKindOfClass:[NSNumber class]]) { // Unshipped items return "false"
            return nil;
        } else {
            return [[NSDateFormatter CocoaBlocJSONDateFormatter] dateFromString:dateShippedValue];
        }
    } reverseBlock:^id(id dateShippedValue) {
        return dateShippedValue == nil ? @NO : [[NSDateFormatter CocoaBlocJSONDateFormatter] stringFromDate:dateShippedValue];
    }];
}

@end
