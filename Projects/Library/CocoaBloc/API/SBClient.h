//
//  SBClient.h
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class SBUser;

/*!
 A client object that manages authentication + requests for a single
 StageBloc user.
 
 NOTE: You must set the current app's client ID and client secret
		 before attempting to make any API calls.
 */
@interface SBClient : AFHTTPRequestOperationManager

/// @name Authentication/Sign Up

/*!
 Set the current app's client ID and client secret, which must be
 registered for use with StageBloc.
 
 @param clientID 		the client ID
 @param clientSecret 	the client secret
 */
+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;

/*!
 Log in a StageBloc user with the given credentials.
 
 @param username the user's username/email address
 @param password the user's password
 
 @return A "cold" signal that will perform the log in on subscription. 
		 The subscribed signal will send a "next" value
		 of an array of admin accounts (SBAccount) for that user (SBUser).
 */
- (RACSignal *)logInWithUsername:(NSString *)username
						password:(NSString *)password;

/*!
 Sign up a new StageBloc user with the given user information and desired credentials.
 
 @param email 		the user's address
 @param password 	the user's password
 @param birthDate 	the user's birth date
 
 @return A "cold" signal that will perform the sign up on subscription.
 		 The subscribed signal will send a "next" value
		 of the newly authenticated user (SBUser).
 */
- (RACSignal *)signUpWithEmail:(NSString *)email
					  password:(NSString *)password
					 birthDate:(NSDate *)birthDate;

/// @name User

/*!
 Request the currently authenticated user from StageBloc.
 NOTE: This is already done on sign in. See the `user` property.
 
 @return A "cold" signal that will perform the request on subscription.
 		 The subscribed signal will send a "next" value of the currently
	     authenticated user's SBUser object. This is the same as the `user` 
 		 property after signing in.
 */
- (RACSignal *)getMe;

/*!
 Request an uploaded audio track on StageBloc by its audio id.
 
 @param audioID 	the track's audio id
 @param accountID	the account to query for the track
 
 @return A "cold" signal that will perform teh request on subscription.
 		 The subscribed signal will send a "next" value of the 
         requested track's <#modelClassName#> object.
 */
- (RACSignal *)getAudioTrackWithID:(NSNumber *)audioID forAccountWithID:(NSNumber *)accountID;

/*!
 Request the StageBloc user by their user id.
 
 @param userID the user id of the user to be requested
 
 @return A "cold" signal that will perform the request on subscription.
 		 The subscribed signal will send a "next" value of the requested
 		 user's representative SBUser object.
 */
- (RACSignal *)getUserWithID:(NSNumber *)userID;

/*!
 
 */
- (RACSignal *)uploadAudioData:(NSData *)data
					 withTitle:(NSString *)title
			   toAccountWithID:(NSNumber *)accountID
				progressSignal:(RACSignal **)progressSignal;

/// @name Fan Clubs

/*!
 
 */
- (RACSignal *)createFanClubForAccountWithID:(NSNumber *)accountID
									   title:(NSString *)title
								 description:(NSString *)description
									tierInfo:(NSDictionary *)tierInfo;

/*!
 
 */
- (RACSignal *)getContentFromFanClubWithParentAccountID:(NSNumber *)accountID
												  limit:(NSUInteger)limit
												 offset:(NSUInteger)offset
								   additionalParameters:(NSDictionary *)parameters;

/*!
 
 */
- (RACSignal *)getRecentFanClubContentWithLimit:(NSUInteger)limit
										 offset:(NSUInteger)offset
						   additionalParameters:(NSDictionary *)parameters;

/*!
 Enqueue a network request with this client. Any configurations
 or authentications will be used for this request.
 
 @param request the network request to enqueue
 
 @return A "cold" signal that will actually enqueue and start the request
 		 upon subscription. It will send a "next" value of the response object
 		 if successful, or the network error if not.
 */
- (RACSignal *)enqueueRequest:(NSURLRequest *)request;

/// The state of authentication for this client instance. Only after signing in a
/// user will this be true.
@property (nonatomic, getter = isAuthenticated, readonly) BOOL authenticated;

/// The oauth2 token for the currently authenticated user. This will be sent
/// in all requests after authentication.
@property (nonatomic, copy, readonly) NSString *token;

/// The authenticated user for this client, or nil if no sign in
/// has been completed yet.
@property (nonatomic, strong) SBUser *user;

@end
