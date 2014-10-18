//
//  SBClient+Store.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Store.h"
#import "SBClient+Private.h"
#import <RACAFNetworking.h>
#import "RACSignal+JSONDeserialization.h"
#import "SBStoreItem.h"
#import "SBOrder.h"

@implementation SBClient (Store)

- (RACSignal *)getStoreItemsForAccount:(SBAccount *)account parameters:(NSDictionary *)parameters {
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithCapacity:8];
    id val;
#define SAFE_ASSIGN(key) if((val = parameters[key])) p[key] = val;
    SAFE_ASSIGN(SBAPIMethodParameterResultLimit);
    SAFE_ASSIGN(SBAPIMethodParameterResultOffset);
    SAFE_ASSIGN(SBAPIMethodParameterResultDirection);
    SAFE_ASSIGN(SBAPIMethodParameterResultOrderBy);
    SAFE_ASSIGN(@"expand");
#undef SAFE_ASSIGN
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/store/items", account.identifier] parameters:[self requestParametersWithParameters:p]]
             	cb_deserializeArrayWithClient:self modelClass:[SBStoreItem class] keyPath:@"data"]
				setNameWithFormat:@"Get store items for account (%@)", account];
}

- (RACSignal *)purchaseItems:(NSArray *)itemsToPurchase usingToken:(NSString *)purchaseToken withAddress:(SBAddress *)address {
    
    NSDictionary *params = @{
                         @"items": itemsToPurchase,
                         @"token": purchaseToken,
                         @"address": @{
                                 @"street_address": address.streetAddress,
                                 @"street_address_2": address.streetAddressTwo,
                                 @"city": address.city,
                                 @"state": address.stateProvince,
                                 @"postal_code": address.postalCode,
                                 @"country": address.country
                        }
                    };
    
    return [[[self rac_POST:@"store/purchase" parameters:[self requestParametersWithParameters:params]]
            	cb_deserializeWithClient:self modelClass:[SBOrder class] keyPath:@"data"]
            setNameWithFormat:@"Purchase items: %@", itemsToPurchase];
}

@end
