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

    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@", accountID] parameters:[self requestParametersWithParameters:nil]]
            	cb_deserializeWithClient:self keyPath:@"data"]
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
            	cb_deserializeWithClient:self keyPath:@"data"]
            	setNameWithFormat:@"Update account (%@)", account];
}

- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account parameters:(NSDictionary*)parameters{
    NSParameterAssert(account);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:parameters.count+1];
    [params addEntriesFromDictionary:parameters];
    params[@"filter"] = @"blog,photos,statuses";

    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/content", account.identifier] parameters:[self requestParametersWithParameters:parameters]]
             cb_deserializeArrayWithClient:self keyPath:@"data"]
            setNameWithFormat:@"Get activity stream for account %@", account.name];
}

- (RACSignal *)getChildrenAccountsForAccount:(NSNumber *)accountId withType:(NSString *)type {
    NSParameterAssert(accountId);

    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/children/%@", accountId, (nil == type ? @"" : type)] parameters:[self requestParametersWithParameters:nil]]
             cb_deserializeArrayWithClient:self keyPath:@"data.child_accounts"]
            setNameWithFormat:@"Get children accounts (accountID: %d])", accountId.intValue];
}

@end
