//
//  SBClient+Auth.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Auth)

/// @name Authentication/Sign Up

+ (instancetype)unauthenticatedClient;
+ (instancetype)authenticatedClientWithToken:(NSString *)token;

/*!
 Set the current app's client ID and client secret, which must be
 registered for use with StageBloc.
 */
+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURI:(NSString *)redirectURI;

/*
 Complete the log in process with an authorization code from StageBloc,
 usually obtained from SBAuthenticationController.
 */
- (RACSignal *)logInWithAuthorizationCode:(NSString *)authorizationCode;

/*!
 Log in a StageBloc user with the given credentials.
 
 @param username the user's username/email address
 @param password the user's password
 
 @return A "cold" signal that will perform the log in upon subscription.
 The subscribed signal will send a "next" value
 of an array of admin accounts (SBAccount) for that user (SBUser).
 */
- (RACSignal *)logInWithUsername:(NSString *)username
                        password:(NSString *)password;

/*!
 Sign up a new StageBloc user with the given user information and desired credentials.
 
 @param email 		the user's address
 @param password 	the user's password
 @param name        the user's full name
 @param birthDate 	the user's birth date
 
 @return A "cold" signal that will perform the sign up upon subscription.
 The subscribed signal will send a "next" value
 of the newly authenticated user (SBUser).
 */
- (RACSignal *)signUpWithEmail:(NSString *)email
                          name:(NSString *)name
                      password:(NSString *)password
                      birthday:(NSDate *)birthday
                        gender:(NSString *)gender
               sourceAccountID:(NSNumber *)sourceAccountID;

/// Method discards the authenticated user and token of the SBClient
-(void)signOutUser;
/// The state of authentication for this client instance. Only after signing in a
/// user will this be true.
@property (nonatomic, getter = isAuthenticated, readonly) BOOL authenticated;

/// The authenticated user for this client, or nil if no sign in
/// has been completed yet.
@property (nonatomic, readonly, strong) SBUser *authenticatedUser;

/// The oauth2 token for the currently authenticated user. This will be sent
/// in all requests after authentication.
@property (nonatomic, copy) NSString *token;

@end
