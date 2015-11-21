//
//  SBAddress.m
//  Pods
//
//  Created by Josh Holat on 10/18/14.
//
//

#import "SBAddress.h"
#import "MTLValueTransformer+CocoaBloc.h"

@implementation SBAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"name"               : @"name",
              @"streetAddress"      : @"street_address",
              @"streetAddressTwo"   : @"street_address_2",
              @"city"               : @"city",
              @"stateProvince"      : @"state",
              @"postalCode"         : @"postal_code",
              @"country"            : @"country"}];
}

@end
