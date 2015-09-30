//
//  SBStoreDashboard.m
//  CocoaBloc
//
//  Created by Mark Glagola on 3/9/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBStoreDashboard.h"
#import <Mantle/MTLValueTransformer.h>
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"

@implementation SBStoreDashboardAverages

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name"            : @"name",
             @"totalOrders"     : @"total_orders",
             @"totalRevenue"    : @"total_revenue"};
}

@end

@implementation SBStoreDashboardTopBuyers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"amountSpent"    : @"amount_spent",
             @"user"           : @"user"};
}

+ (MTLValueTransformer *)userJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end

@implementation SBStoreDashboard


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"averageFanValue"               : @"averages.fan_value",
              @"averageOrderPrice"             : @"averages.order_price",
              @"fanClubRevenue"                : @"revenue.fan_club",
              @"storeRevenue"                  : @"revenue.store",
              @"totalOrders"                   : @"totals.orders",
              @"totalRevenue"                  : @"totals.revenue",
              @"totalShippingHandling"         : @"totals.shipping_handling",
              @"totalTaxes"                    : @"totals.tax",
              @"topBuyers"                     : @"top_buyers",
              @"countries"                     : @"countries",
              }];
}

+ (MTLValueTransformer *)topBuyersJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBStoreDashboardTopBuyers class]];
}

+ (MTLValueTransformer *)countriesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^NSDictionary *(NSDictionary *countries, BOOL *success, NSError **error) {
        *success = YES;
        if (![countries isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in countries.allKeys) {
            id model = [MTLJSONAdapter modelOfClass:[SBStoreDashboardAverages class] fromJSONDictionary:countries[key] error:error];
            if (*error != nil) {
                *success = NO;
                return nil;
            }
            [dict setValue:model forKey:key];
        };
        
        return [dict copy];
    } reverseBlock:^NSDictionary *(NSDictionary *countries, BOOL *success, NSError **error) {
        *success = YES;
        if (![countries isKindOfClass:[NSDictionary class]]) {
            return nil;
        }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in countries.allKeys) {
            NSDictionary *modelDict = [MTLJSONAdapter JSONDictionaryFromModel:countries[key] error:error];
            if (*error != nil) {
                *success = NO;
                return nil;
            }
            [dict setValue:modelDict forKey:key];
        };

        return [dict copy];
    }];
}

@end
