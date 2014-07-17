//
//  SBClient.h
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class SBUser;
@interface SBClient : AFHTTPRequestOperationManager

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password;
- (RACSignal *)signUpWithUsername:(NSString *)username password:(NSString *)password birthDate:(NSDate *)birthDate;

- (RACSignal *)getMe;

- (RACSignal *)enqueueRequest:(NSURLRequest *)request;

@property (nonatomic, getter = isAuthenticated, readonly) BOOL authenticated;
@property (nonatomic, copy, readonly) NSString *token;

@end
