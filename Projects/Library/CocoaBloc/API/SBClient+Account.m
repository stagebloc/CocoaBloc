//
//  SBClient+Account.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Account.h"
#import <RACAFNetworking.h>

@implementation SBClient (Account)

- (RACSignal *)getAccountWithID:(NSNumber *)accountID {
    return [[self rac_GET:[NSString stringWithFormat:@"account/%@", accountID] parameters:nil]
    			map:^id(NSDictionary *response) {
                    
                }];
}

- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account {
    
}

- (RACSignal *)getChildrenAccountsForAccount:(SBAccount *)account {
    
}

@end
