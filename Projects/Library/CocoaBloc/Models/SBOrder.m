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
#import <RACCommand.h>
#import <RACEXTScope.h>
#import "SBClient+Account.h"
#import "SBClient+User.h"

@interface SBOrder ()
@property (nonatomic, readonly) RACCommand *fetchCustomerUserCommand;
@property (nonatomic, readonly) RACCommand *fetchAccountCommand;
@end

@implementation SBOrder

- (RACSignal *)fetchCustomerUser {
    return [self.fetchCustomerUserCommand execute:nil];
}

- (RACSignal *)fetchAccount {
    return [self.fetchAccountCommand execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchCustomerUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.customerUser != nil
            ? [RACSignal return:self.customerUser]
            : [[[SBClient new] getUserWithID:self.customerUserID]
               doNext:^(SBUser *user) {
                   self.customerUser = user;
               }];
        }];
        
        _fetchAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.account != nil
            ? [RACSignal return:self.account]
            : [[[SBClient new] getAccountWithID:self.accountID]
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
              @"totalUsd"                   : @"total_usd",
              @"fetchAccountCommand"        : [NSNull null],
              @"fetchCustomerUser"          : [NSNull null]
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
