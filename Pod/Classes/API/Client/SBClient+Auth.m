//
//  SBClient+Auth.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "SBClient+Auth.h"
#import "SBClient+Private.h"
#import "SBClient.h"
#import "SBClient+User.h"
#import "NSObject+AssociatedObjects.h"

@interface SBClient (AuthInternal)
@property (nonatomic, readwrite) SBUser *authenticatedUser;
@end

@implementation RACSignal (SBClientPrivate)

- (RACSignal *)_processedAuthSignalForClient:(SBClient *)client {
    @weakify(client);
    
    return [[[self
              flattenMap:^RACStream *(RACTuple *objectAndResponse) {
                  NSDictionary *response = objectAndResponse.first;
                    // deserialize the user
                    SBUser *user = [MTLJSONAdapter modelOfClass:[SBUser class]
                                             fromJSONDictionary:[response valueForKeyPath:@"data.user"]
                                                          error:nil];
                    user.adminAccounts = [MTLJSONAdapter modelsOfClass:[SBAccount class]
                                                         fromJSONArray:[response valueForKeyPath:@"data.admin_accounts"]
                                                                 error:nil];
                    
                    return [RACSignal zip:@[[RACSignal return:user], [RACSignal return:response[@"data"][@"access_token"]]]];
                }]
                doNext:^(RACTuple *userAndToken) {
                    @strongify(client);
                    
                    // set the currently authenticated user & token
                    client.authenticatedUser = userAndToken.first;
                    client.token = userAndToken.second;
                }]
                map:^id(RACTuple *userAndToken) {
                    return userAndToken.first;
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
    
    return [[[self rac_POST:@"oauth2/token" parameters:[self requestParametersWithParameters: @{@"grant_type"				: @"password",
                                                                                                @"username"					: username,
                                                                                                @"password"					: password,
                                                                                                @"client_secret"			: SBClientSecret,
                                                                                                @"client_id"				: SBClientID,
                                                                                                @"expand"					: @"user",
                                                                                                @"include_admin_accounts" 	: @YES}]]
				_processedAuthSignalForClient:self]
            	setNameWithFormat:@"Log In (username: %@, password: %@)", username, password];
}

- (RACSignal *)logInWithAuthorizationCode:(NSString *)authorizationCode {
    NSParameterAssert(authorizationCode);
    
    return [[self rac_POST:@"oauth2/token" parameters:
            [self requestParametersWithParameters:@{@"code"					: authorizationCode,
                                                     @"client_secret"			: SBClientSecret,
                                                     @"expand"					: @"user",
                                                     @"include_admin_accounts"	: @YES,
                                                     @"grant_type"				: @"authorization_code"}]]
            	_processedAuthSignalForClient:self];
}

- (RACSignal *)signUpWithEmail:(NSString *)email
                          name:(NSString *)name
                      password:(NSString *)password
                      birthday:(NSDate *)birthday
                        gender:(NSString *)gender
              sourceAccountID:(NSNumber *)sourceAccountID {
    // Required signup parameters
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSParameterAssert(birthday);

    NSDateFormatter *df = [NSDateFormatter new];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"EN_US_POSIX"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *birthdayString = [df stringFromDate:birthday];

    // Required
    NSMutableDictionary *params = [NSMutableDictionary  dictionaryWithDictionary:@{@"email" : email,
                                                                                   @"password" : password,
                                                                                   @"birthday" : birthdayString}];
    // Optional
    if (name)               params[@"name"] = name.copy;
    if (gender)             params[@"gender"] = gender.copy;
    if (sourceAccountID) 	params[@"source_account_id"] = sourceAccountID.copy;

    return [[self rac_POST:@"users" parameters:[self requestParametersWithParameters:params]]
            _processedAuthSignalForClient:self];
}

- (void)signOutUser {
    self.authenticatedUser = nil;
    self.token = nil;
}

@end
