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
		 that is an array of admin accounts (SBAccount) for that user (SBUser).
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
		 that is the newly authenticated user (SBUser).
 */
- (RACSignal *)signUpWithEmail:(NSString *)email
					  password:(NSString *)password
					 birthDate:(NSDate *)birthDate;

/*!
 
 */
- (RACSignal *)getMe;
- (RACSignal *)getAudioWithID:(NSNumber *)audioID;
- (RACSignal *)getUserWithID:(NSNumber *)userID;

- (RACSignal *)uploadAudioData:(NSData *)data
					 withTitle:(NSString *)title
			   toAccountWithID:(NSNumber *)accountID;

- (RACSignal *)createFanClubForAccountWithID:(NSNumber *)accountID
									   title:(NSString *)title
								 description:(NSString *)description
									tierInfo:(NSDictionary *)tierInfo;

- (RACSignal *)getContentFromFanClubWithParentAccountID:(NSNumber *)accountID
												  limit:(NSUInteger)limit
												 offset:(NSUInteger)offset
								   additionalParameters:(NSDictionary *)parameters;

- (RACSignal *)getRecentFanClubContentWithLimit:(NSUInteger)limit
										 offset:(NSUInteger)offset
						   additionalParameters:(NSDictionary *)parameters;

- (RACSignal *)enqueueRequest:(NSURLRequest *)request;

@property (nonatomic, getter = isAuthenticated, readonly) BOOL authenticated;
@property (nonatomic, copy, readonly) NSString *token;

@end
