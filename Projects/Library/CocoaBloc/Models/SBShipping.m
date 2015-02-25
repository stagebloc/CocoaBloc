//
//  SBShipping.m
//  CocoaBloc
//
//  Created by John Heaton on 2/25/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBShipping.h"
#import "MTLValueTransformer+Convenience.h"

@implementation SBShippingMethod

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"commitment"     : @"commitment",
              @"handlingPrice"  : @"handling",
              @"price"          : @"price",
              @"name"           : @"name"}];
}

@end

@implementation SBShippingPriceHandler

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"shippingMethods" : @"shipping_methods"}];
}

+ (MTLValueTransformer *)shippingMethodsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBShippingMethod class]];
}

@end

@implementation SBShippingFulfiller

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"postalCode"     : @"postal_code",
              @"name"           : @"name",
              @"priceHandlers"  : @"shipping_price_handlers"}];
}

+ (MTLValueTransformer *)priceHandlersJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBShippingPriceHandler class]];
}

@end

@implementation SBShippingRate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fulfillers" : @"fulfillers"};
}

+ (MTLValueTransformer *)fulfillersJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBShippingFulfiller class]];
}

@end

@implementation SBShippingRateSet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"ordersRate"      : @"order",
             @"preOrdersRate"   : @"pre_order"};
}

+ (MTLValueTransformer *)ordersRateJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBShippingRate class]];
}

+ (MTLValueTransformer *)preOrdersRateJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBShippingRate class]];
}

@end