//
//  SBAddress.m
//  Pods
//
//  Created by Josh Holat on 10/18/14.
//
//

#import "SBAddress.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>

@implementation SBAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"streetAddress"      : @"street_address",
              @"streetAddressTwo"   : @"street_address_2",
              @"city"               : @"city",
              @"stateProvince"      : @"state",
              @"postalCode"         : @"postal_code",
              @"country"            : @"country"}];
}

@end
