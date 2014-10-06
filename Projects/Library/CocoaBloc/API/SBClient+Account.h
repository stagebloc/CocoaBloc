//
//  SBClient+Account.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Account)

- (RACSignal *)getAccountWithID:(NSNumber *)accountID;
- (RACSignal *)updateAccountWithID:(NSNumber *)accountID name:(NSString *)name description:(NSString *)description stageBlocURL:(NSString *)urlString;
- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account;
- (RACSignal *)getChildrenAccountsForAccount:(SBAccount *)account;

@end
