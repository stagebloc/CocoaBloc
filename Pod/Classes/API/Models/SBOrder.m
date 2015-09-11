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
#import <ReactiveCocoa/RACCommand.h>
#import <ReactiveCocoa/RACExtScope.h>
#import "SBClient+Account.h"
#import "SBClient+User.h"
#import <ReactiveCocoa/RACSignal.h>

@implementation SBOrder {
    RACCommand *_fetchCustomerUserCommand;
    RACCommand *_fetchAccountCommand;
}

- (RACSignal *)fetchCustomerUser {
    return [self fetchCustomerUserWithClient:nil];
}

- (RACSignal *)fetchCustomerUserWithClient:(SBClient*)client {
    return [_fetchCustomerUserCommand execute:client];
}

- (RACSignal *)fetchAccount {
    return [self fetchAccountWithClient:nil];
}

- (RACSignal *)fetchAccountWithClient:(SBClient*)client {
    return [_fetchAccountCommand execute:client];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchCustomerUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];
            
            return self.customerUser != nil
            ? [RACSignal return:self.customerUser]
            : [[client getUserWithID:self.customerUserID]
               doNext:^(SBUser *user) {
                   self.customerUser = user;
               }];
        }];
        
        _fetchAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];
            
            return self.account != nil
            ? [RACSignal return:self.account]
            : [[client getAccountWithID:self.accountID]
               doNext:^(SBAccount *account) {
                   self.account = account;
               }];
        }];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"dateOrdered"                : @"ordered",
              @"dateShipped"                : @"shipped",
              @"email"                      : @"email",
              @"customerUserID"             : @"user",
              @"customerUser"               : @"user",
              @"accountID"                  : @"account",
              @"account"                    : @"account",
              @"address"                    : @"address",
              @"stripeChargeId"             : @"stripe_charge_id",
              @"totalUsd"                   : @"total_usd"
              }];
}

+ (MTLValueTransformer *)customerIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)customerJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)accountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)addressJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)dateOrderedJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)dateShippedJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

@end
