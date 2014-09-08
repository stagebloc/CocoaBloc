//
//  SBClient+Auth.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Auth.h"

@implementation SBClient (Auth)

// global client id/secret (global is it should be one per app)
static NSString *SBClientID, *SBClientSecret;

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    SBClientID = clientID.copy;
    SBClientSecret = clientSecret.copy;
}


- (void)setToken:(NSString *)token {
    if (![token isEqual:self.token]) { // only change if it's different
        
        // keep the KVO compliance for observing token
        [self willChangeValueForKey:@"token"];
        
        // clear it if nil
        if (!token) {
            [self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        } else {
            // else set it
            _token = token.copy;
            [self.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forHTTPHeaderField:@"Authorization"];
        }
        [self didChangeValueForKey:@"token"];
    }
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    @weakify(self);
    
    return [[[[[self rac_POST:@"oauth2/token" parameters:@{	@"grant_type"	: @"password",
                                                            @"username"		: username,
                                                            @"password"		: password,
                                                            @"client_secret": SBClientSecret,
                                                            @"client_id"		: SBClientID,
                                                            @"include_user" : @"1",
                                                            @"include_admin_accounts" : @"1"}]
               doNext:^(NSDictionary *response) {
                   @strongify(self);
                   
                   // set the auth token & auth state when a 'next' is sent
                   self.token = response[@"access_token"];
                   self.authenticated = YES;
               }]
              map:^id(NSDictionary *response) {
                  // deserialize the user
                  SBUser *user = [MTLJSONAdapter modelOfClass:[SBUser class]
                                           fromJSONDictionary:response[@"data"][@"user"]
                                                        error:nil];
                  user.adminAccounts = [MTLJSONAdapter
                                        modelsOfClass:[SBAccount class]
                                        fromJSONArray:response[@"data"][@"admin_accounts"]
                                        error:nil];
                  
                  return user;
              }]
             doNext:^(SBUser *user) {
                 @strongify(self);
                 
                 // set the currently authenticated user
                 self.user = user;
             }]
            setNameWithFormat:@"Log In (username: %@, password: %@)", username, password];
}

- (RACSignal *)signUpWithEmail:(NSString *)email
                      password:(NSString *)password
                     birthDate:(NSDate *)birthDate {
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSParameterAssert(birthDate);
    
    return [RACSignal error:nil];
}


@end
