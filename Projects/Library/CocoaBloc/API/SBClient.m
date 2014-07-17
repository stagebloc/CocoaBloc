//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import <RACAFNetworking.h>

@interface SBClient ()
@property (nonatomic, assign, readwrite) BOOL authenticated;
@property (nonatomic, copy, readwrite) NSString *token;
@end

@implementation SBClient

static NSString *SBClientID, *SBClientSecret;
+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
	SBClientID = clientID.copy;
	SBClientSecret = clientSecret.copy;
}

- (id)init {
	self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.stagebloc.com/v1"]];
	if (self) {
		self.securityPolicy.allowInvalidCertificates = YES;
	}

	return self;
}

- (void)setToken:(NSString *)token {
	if (![token isEqual:self.token]) {
		[self willChangeValueForKey:@"token"];
		if (!token) {
			[self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        } else {
			_token = token.copy;
			[self.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forHTTPHeaderField:@"Authorization"];
		}
		[self didChangeValueForKey:@"token"];
    }
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    return [[[[self rac_POST:@"oauth2/token"
				parameters:@{@"grant_type"    : @"password",
							   @"username"      : username,
							   @"password"      : password,
							   @"client_secret" : SBClientSecret,
							   @"client_id"     : SBClientID,
							   @"include_admin_accounts" : @"1"}]
			  	doNext:^(NSDictionary *response) {
					self.token = response[@"access_token"];
					self.authenticated = YES;
				}]
				map:^id(NSDictionary *response) {
					NSArray *accounts =
					[MTLJSONAdapter modelsOfClass:[SBAccount class]
									fromJSONArray:response[@"data"][@"admin_accounts"]
											error:nil];
				 
					return accounts;
				}]
				setNameWithFormat:@"Log In"];
}

- (RACSignal *)signUpWithUsername:(NSString *)username password:(NSString *)password birthDate:(NSDate *)birthDate {
	NSParameterAssert(username);
	NSParameterAssert(password);
	NSParameterAssert(birthDate);
    
	return [RACSignal error:nil];
}

- (RACSignal *)getMe {
	return [[[self rac_GET:@"users/me" parameters:nil]
				map:^id(NSDictionary *response) {
					return [MTLJSONAdapter modelOfClass:[SBUser class] fromJSONDictionary:response[@"data"] error:nil];
				}]
				setNameWithFormat:@"Get \"me\""];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
	return [self rac_enqueueHTTPRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
}

@end
