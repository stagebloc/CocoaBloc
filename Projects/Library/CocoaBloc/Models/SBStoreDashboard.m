//
//  SBStoreDashboard.m
//  CocoaBloc
//
//  Created by Mark Glagola on 3/9/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBStoreDashboard.h"
#import <MTLValueTransformer.h>
#import <NSDictionary+MTLManipulationAdditions.h>
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
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSArray *(NSArray *objects) {
        return [MTLJSONAdapter modelsOfClass:[SBStoreDashboardTopBuyers class] fromJSONArray:objects error:nil];
    } reverseBlock:^NSArray *(NSArray *objects) {
        return [MTLJSONAdapter JSONArrayFromModels:objects];
    }];
}

+ (MTLValueTransformer *)countriesJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSDictionary *(NSDictionary *countries) {
        __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [countries enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
            [dict setValue:[MTLJSONAdapter modelOfClass:[SBStoreDashboardAverages class] fromJSONDictionary:obj error:nil] forKey:key];
        }];
        return [dict copy];
    } reverseBlock:^NSDictionary *(NSDictionary *countries) {
        __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [countries enumerateKeysAndObjectsUsingBlock:^(NSString *key, SBStoreDashboardAverages *avgs, BOOL *stop) {
            [dict setValue:[MTLJSONAdapter JSONDictionaryFromModel:avgs] forKey:key];
        }];
        return [dict copy];
    }];
}

@end
