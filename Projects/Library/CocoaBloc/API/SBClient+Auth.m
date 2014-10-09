//
//  SBClient+Auth.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Auth.h"
#import "SBClient.h"
#import "SBClient+User.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>
#import "NSObject+AssociatedObjects.h"

@interface SBClient (AuthInternal)
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, strong, readwrite) SBUser *authenticatedUser;
@end

@implementation SBClient (Auth)

// global client id/secret (global is it should be one per app)
NSString *SBClientID, *SBClientSecret;

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    SBClientID = clientID.copy;
    SBClientSecret = clientSecret.copy;
}

- (void)setToken:(NSString *)token {
    if (![token isEqual:self.token]) { // only change if it's different
        
        // keep the KVO compliance for observing token
        [self willChangeValueForKey:@"token"];
        [self willChangeValueForKey:@"authenticated"];
        
        [self setAssociatedObject:token forKey:@"token" policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
        
        // clear it if nil
        if (!token) {
            [self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        } else {
            // else set it
            [self.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forHTTPHeaderField:@"Authorization"];
        }
        [self didChangeValueForKey:@"token"];
        [self didChangeValueForKey:@"authenticated"];
    }
}

- (NSString *)token {
    return [self associatedObjectForKey:@"token"];
}

- (BOOL)isAuthenticated {
    return self.token != nil;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    if ([theKey isEqualToString:@"token"] || [theKey isEqualToString:@"authenticated"]) {
        return NO;
    }
    
    return [super automaticallyNotifiesObserversForKey:theKey];
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    @weakify(self);
    
    return [[[[[[self rac_POST:@"oauth2/token" parameters:@{@"grant_type"				: @"password",
                                                            @"username"					: username,
                                                            @"password"					: password,
                                                            @"client_secret"			: SBClientSecret,
                                                            @"client_id"				: SBClientID,
                                                            @"expand"					: @"user",
                                                            @"include_user" 			: @"1",
                                                            @"include_admin_accounts" 	: @"1"}]
            	doNext:^(NSDictionary *response) {
                   	@strongify(self);
                   
                   	// set the auth token & auth state when a 'next' is sent
                   	self.token = response[@"data"][@"access_token"];
               	}]
                doError:^(NSError *error) {
                    
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
                 	self.authenticatedUser = user;
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
