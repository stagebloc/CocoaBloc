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

- (RACSignal *)getStoreItemWithID:(NSNumber *)storeItemID forAccountWithIdentifier:(NSNumber *)accountIdentifier {
    return [[[self rac_GET:[NSString stringWithFormat:@"/v1/account/%@/store/items/%d", accountIdentifier, storeItemID.intValue] parameters:[self requestParametersWithParameters:nil]]
             	cb_deserializeArrayWithClient:self keyPath:@"data"]
            	setNameWithFormat:@"Get store item (accountID: %@, audioID: %d)", accountIdentifier, storeItemID.intValue];
}

- (RACSignal *)getStoreItemsForAccountWithIdentifier:(NSNumber *)accountIdentifier parameters:(NSDictionary *)parameters {
    NSParameterAssert(accountIdentifier);
    
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithCapacity:8];
    id val;
#define SAFE_ASSIGN(key) if((val = parameters[key])) p[key] = val;
    SAFE_ASSIGN(SBAPIMethodParameterResultLimit);
    SAFE_ASSIGN(SBAPIMethodParameterResultOffset);
    SAFE_ASSIGN(SBAPIMethodParameterResultDirection);
    SAFE_ASSIGN(SBAPIMethodParameterResultOrderBy);
    SAFE_ASSIGN(@"expand");
#undef SAFE_ASSIGN
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/store/items", accountIdentifier] parameters:[self requestParametersWithParameters:p]]
             	cb_deserializeArrayWithClient:self keyPath:@"data"]
				setNameWithFormat:@"Get store items for account (%@)", accountIdentifier];
}

- (RACSignal *)getShippingRatesForItems:(NSArray *)itemsToPurchase withAddress:(SBAddress *)address
{
    NSDictionary *JSONaddress = [MTLJSONAdapter JSONDictionaryFromModel:address];
    NSDictionary *params = @{
                             @"items": itemsToPurchase,
                             @"address": JSONaddress
                        };

    return [[self rac_POST:@"store/shipping/rates" parameters:[self requestParametersWithParameters:params]]
            setNameWithFormat:@"Shipping rates for items: %@", itemsToPurchase];
}

- (RACSignal *)purchaseItems:(NSDictionary *)itemsToPurchase
                  usingToken:(NSString *)purchaseToken
                 withAddress:(SBAddress *)address
             shippingDetails:(NSDictionary *)shippingDetails
                      totals:(NSDictionary *)totals
                       notes:(NSString *)notes
                    andEmail:(NSString *)email
                  forAccount:(NSNumber *)accountId
                  parameters:(NSDictionary *)parameters {
    NSDictionary *JSONaddress = [MTLJSONAdapter JSONDictionaryFromModel:address];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                         @"cart": @{@"store": itemsToPurchase},
                         @"notes": notes,
                         @"token": purchaseToken,
                         @"totals": totals,
                         @"address": JSONaddress,
                         @"shipping": shippingDetails
                    }];
    
    [params addEntriesFromDictionary:parameters];

    if (email == nil) {
        if (!self.authenticatedUser) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendError:[[NSError alloc] initWithDomain:@"com.stagebloc.cocoabloc" code:400 userInfo:@{@"message" : @"An email or authenticated user must be used"}]];
                return nil;
            }];
        }
    } else {
        [params setValue:email forKey:@"email"];
    }
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/store/purchase", accountId] parameters:[self requestParametersWithParameters:params]]
            	cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Purchase items: %@", itemsToPurchase];
}

- (RACSignal *)addPaymentForSplitPurchaseForOrderWithID:(NSNumber *)orderID
                                                 amount:(NSDecimalNumber *)amount
                                                  token:(NSString *)token
                                              accountID:(NSNumber *)accountID
                                             parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if (token != nil) {
        params[@"token"] = token;
    }
    params[@"amount"] = amount;
    params[@"orderId"] = orderID;
    
    return [self rac_POST:[NSString stringWithFormat:@"account/%@/store/purchase/split", accountID.stringValue] parameters:[self requestParametersWithParameters:params]];
}

- (RACSignal*)requestStripeAuthorizationWithToken:(NSString *)requestToken forAccountWithID:(NSNumber *)accountID {
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%d/store/stripe", accountID.intValue] parameters:@{@"token":requestToken}]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Request stripe auth with token %@ for account %@", requestToken, accountID.stringValue];
}

@end
