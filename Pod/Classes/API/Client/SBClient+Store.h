//
//  SBClient+Store.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBAddress.h"

@interface SBClient (Store)

/*!
 Requests tax and shipping information for a given cart and address.

 @param accountID of account from which items are being purchased
 @param address SBAddress for which to fetch tax and shipping info
 @param items NSDictionary of cart for which to fetch tax and shipping info

 Returns RACTuple -> first object = SBShippingRateSet, second object = NSDecimalNumber (taxTotal)
 */
- (RACSignal *)getShippingRatesAndTaxForAccountWithIdentifier:(NSNumber *)accountID
                                                      address:(SBAddress *)address
                                                     forItems:(NSDictionary *)items;

- (RACSignal *)getStoreItemsForAccountWithIdentifier:(NSNumber *)accountIdentifier parameters:(NSDictionary *)parameters;

- (RACSignal *)getStoreItemWithID:(NSNumber *)storeItemID forAccountWithIdentifier:(NSNumber *)accountIdentifier;

- (RACSignal *)purchaseItems:(NSDictionary *)items
                  usingToken:(NSString *)purchaseToken
                 withAddress:(SBAddress *)address
             shippingDetails:(NSDictionary *)shippingDetails
                      totals:(NSDictionary *)totals
                       notes:(NSString *)notes
                    andEmail:(NSString *)email
                  forAccount:(NSNumber *)accountId
                  parameters:(NSDictionary *)parameters;

- (RACSignal *)addPaymentForSplitPurchaseForOrderWithID:(NSNumber *)orderID
                                                 amount:(NSDecimalNumber *)amount
                                                  token:(NSString *)token
                                              accountID:(NSNumber *)accountID
                                             parameters:(NSDictionary *)parameters;

- (RACSignal *)requestStripeAuthorizationWithToken:(NSString*)requestToken forAccountWithID:(NSNumber*)accountID;

- (RACSignal *)getStoreDashboardWithAccountIdentifier:(NSNumber *)accountIdentifier parameters:(NSDictionary *)parameters;


@end
