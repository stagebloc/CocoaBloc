//
//  SBClient+Account.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Account.h"
#import <RACAFNetworking.h>
#import "SBAccount.h"
#import "RACSignal+JSONDeserialization.h"

@implementation SBClient (Account)

- (RACSignal *)getAccountWithID:(NSNumber *)accountID {
    NSParameterAssert(accountID);
    
    return [[self rac_GET:[NSString stringWithFormat:@"account/%@", accountID] parameters:nil]
    			map:^id(NSDictionary *response) {
                    return [MTLJSONAdapter modelOfClass:[SBAccount class]
                                     fromJSONDictionary:response[@"data"]
                                                  error:nil];
                }];
}

- (RACSignal *)updateAccountWithID:(NSNumber *)accountID
                              name:(NSString *)name
                       description:(NSString *)description
                      stageBlocURL:(NSString *)urlString {
    NSParameterAssert(accountID);
    NSAssert(name != nil || description != nil || urlString != nil, @"To update the account, provide at least one property to update.");
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (name) 			dict[@"name"] = name.copy;
    if (description) 	dict[@"description"] = description.copy;
    if (urlString)		dict[@"stagebloc_url"] = urlString.copy;
    
    return [[self rac_POST:[NSString stringWithFormat:@"account/%@", accountID] parameters:dict]
            	cb_deserializeWithClient:self modelClass:[SBAccount class]];
}

- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account {
    NSParameterAssert(account);
    
    return [[self rac_GET:[NSString stringWithFormat:@"account/%@/content", account.identifier] parameters:nil]
            	map:^id(NSDictionary *response) {
                    return response;
                }];
}

- (RACSignal *)getChildrenAccountsForAccount:(SBAccount *)account {
    return nil;
}

@end
