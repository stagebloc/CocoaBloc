//
//  SBClient+Account.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Account.h"
#import <RACAFNetworking.h>
#import "SBClient+Private.h"
#import "SBAccount.h"
#import "RACSignal+JSONDeserialization.h"

@implementation SBClient (Account)

- (RACSignal *)getAccountWithID:(NSNumber *)accountID {
    NSParameterAssert(accountID);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@", accountID] parameters:nil]
            	cb_deserializeWithClient:self modelClass:[SBAccount class] keyPath:@"data"]
            	setNameWithFormat:@"Get account with ID: %@", accountID];
}

- (RACSignal *)updateAccount:(SBAccount *)account
                        name:(NSString *)name
                 description:(NSString *)description
                stageBlocURL:(NSString *)urlString {
    NSParameterAssert(account);
    NSAssert(name != nil || description != nil || urlString != nil, @"To update the account, provide at least one property to update.");
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (name) 			dict[@"name"] = name.copy;
    if (description) 	dict[@"description"] = description.copy;
    if (urlString)		dict[@"stagebloc_url"] = urlString.copy;
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@", account.identifier] parameters:[self requestParametersWithParameters:dict]]
            	cb_deserializeWithClient:self modelClass:[SBAccount class] keyPath:@"data"]
            	setNameWithFormat:@"Update account (%@)", account];
}

- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account {
    NSParameterAssert(account);
    
    return [[self rac_GET:[NSString stringWithFormat:@"account/%@/content", account.identifier] parameters:nil]
    			map:^id(NSDictionary *response) {
                    return response;
                }];        	
}

//- (RACSignal *)getChildrenAccountsForAccount:(SBAccount *)account {
//    NSParameterAssert(account);
//    
//    return [[self rac_GET:[NSString stringWithFormat:] parameters:]]
//}

@end
