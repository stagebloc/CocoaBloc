//
//  SBClient+Auth.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Auth.h"
#import "SBClient+Private.h"
#import "SBClient.h"
#import "SBClient+User.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>
#import "NSObject+AssociatedObjects.h"

@interface SBClient (AuthInternal)
@property (nonatomic, readwrite) SBUser *authenticatedUser;
@end

@implementation RACSignal (SBClientPrivate)

- (RACSignal *)_processedAuthSignalForClient:(SBClient *)client {
    @weakify(client);
    
    return [[[self
              doNext:^(NSDictionary *response) {
                  @strongify(client);
                  
                  // set the auth token & auth state when a 'next' is sent
                  client.token = response[@"data"][@"access_token"];
              }]
             map:^id(NSDictionary *response) {
                 // deserialize the user
                 SBUser *user = [MTLJSONAdapter modelOfClass:[SBUser class]
                                          fromJSONDictionary:response[@"data"][@"user"]
                                                       error:nil];
                 user.adminAccounts = [MTLJSONAdapter modelsOfClass:[SBAccount class]
                                                      fromJSONArray:response[@"data"][@"admin_accounts"]
                                                              error:nil];
                 
                 return user;
             }]
            doNext:^(SBUser *user) {
                @strongify(client);
                
                // set the currently authenticated user
                client.authenticatedUser = user;
            }];
}

@end

@implementation SBClient (Auth)

+ (instancetype)unauthenticatedClient {
    return [self new];
}

+ (instancetype)authenticatedClientWithToken:(NSString *)token {
    SBClient *s = [self new];
    s.token = token;
    return s;
}

// global client id/secret (global is it should be one per app)
NSString *SBClientID, *SBClientSecret, *SBRedirectURI;

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURI:(NSString *)redirectURI {
    SBClientID = clientID.copy;
    SBClientSecret = clientSecret.copy;
    SBRedirectURI = redirectURI.copy;
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
    if ([theKey isEqualToString:@"token"] ||
        [theKey isEqualToString:@"authenticated"] ||
        [theKey isEqualToString:@"authenticatedUser"]) {
        return NO;
    }
    
    return [super automaticallyNotifiesObserversForKey:theKey];
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    return [[[self rac_POST:@"oauth2/token" parameters:@{@"grant_type"				: @"password",
                                                            @"username"					: username,
                                                            @"password"					: password,
                                                            @"client_secret"			: SBClientSecret,
                                                            @"client_id"				: SBClientID,
                                                            @"expand"					: @"user",
                                                            @"include_admin_accounts" 	: @"1"}]
				_processedAuthSignalForClient:self]
            	setNameWithFormat:@"Log In (username: %@, password: %@)", username, password];
}

- (RACSignal *)logInWithAuthorizationCode:(NSString *)authorizationCode {
    NSParameterAssert(authorizationCode);
    
    return [[self rac_POST:@"oauth2/token" parameters:
            [self requestParametersWithParameters:@{@"code"					: authorizationCode,
                                                     @"client_secret"			: SBClientSecret,
                                                     @"expand"					: @"user",
                                                     @"include_admin_accounts"	: @"1",
                                                     @"grant_type"				: @"authorization_code"}]]
            	_processedAuthSignalForClient:self];
}

- (RACSignal *)signUpWithEmail:(NSString *)email
                      password:(NSString *)password
                      birthday:(NSDate *)birthday
                        gender:(NSString *)gender
              sourceAccountID:(NSNumber *)sourceAccountID
{
    // Required signup parameters
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSParameterAssert(birthday);

    NSDateFormatter *df = [NSDateFormatter new];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"EN_US_POSIX"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *birthdayString = [df stringFromDate:birthday];

    NSDictionary *p = @{@"email" : email,
                        @"password" : password,
                        @"birthday" : birthdayString};

    // Optional signup parameters
    NSMutableDictionary *params = [NSMutableDictionary  dictionaryWithDictionary:p];
    if (gender) {
        [params addEntriesFromDictionary:@{@"gender" : gender}];
    }
    if (sourceAccountID) {
        [params addEntriesFromDictionary:@{@"source_account_id" : sourceAccountID}];
    }
    
    @weakify(self);

    return [[[[self rac_POST:@"users" parameters:[self requestParametersWithParameters:params]]
            doNext:^(NSDictionary *response) {
                @strongify(self);

                // set the auth token & auth state when a 'next' is sent
                self.token = response[@"data"][@"access_token"];
            }]

            map:^id(NSDictionary *response) {

                // deserialize the user
                SBUser *user = [MTLJSONAdapter modelOfClass:[SBUser class]
                                         fromJSONDictionary:response[@"data"][@"user"]
                                                      error:nil];

                user.adminAccounts = [MTLJSONAdapter modelsOfClass:[SBAccount class]
                                                     fromJSONArray:response[@"data"][@"admin_accounts"]
                                                             error:nil];
                return user;
            }]
            doNext:^(SBUser *user) {
                @strongify(self);

                // set the currently authenticated user
                self.authenticatedUser = user;
            }];
}

-(void)signOutUser
{
    self.authenticatedUser = nil;
    self.token = nil;
}

@end
