//
//  SBClient+Store.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Store.h"
#import <RACAFNetworking.h>
#import "RACSignal+JSONDeserialization.h"
#import "SBStoreItem.h"

@implementation SBClient (Store)

- (RACSignal *)getStoreItemsForAccount:(SBAccount *)account parameters:(NSDictionary *)parameters {
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithCapacity:8];
    id val;
#define SAFE_ASSIGN(key) if((val = parameters[key])) p[key] = val;
    SAFE_ASSIGN(SBAPIMethodParameterResultLimit);
    SAFE_ASSIGN(SBAPIMethodParameterResultOffset);
    SAFE_ASSIGN(SBAPIMethodParameterResultDirection);
    SAFE_ASSIGN(SBAPIMethodParameterResultOrderBy);
#undef SAFE_ASSIGN
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/store/items", account.identifier] parameters:p]
             	cb_deserializeArrayWithClient:self modelClass:[SBStoreItem class] keyPath:@"data"]
				setNameWithFormat:@"Get store items for account (%@)", account];
}

@end
