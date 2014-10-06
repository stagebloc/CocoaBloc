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

@implementation SBClient (Account)

- (RACSignal *)getAccountWithID:(NSNumber *)accountID {
    return [[self rac_GET:[NSString stringWithFormat:@"account/%@", accountID] parameters:nil]
    			map:^id(NSDictionary *response) {
                    return [MTLJSONAdapter modelOfClass:[SBAccount class]
                                     fromJSONDictionary:response[@"data"]
                                                  error:nil];
                }];
}

- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account {
    return nil;
}

- (RACSignal *)getChildrenAccountsForAccount:(SBAccount *)account {
    return nil;
}

@end
