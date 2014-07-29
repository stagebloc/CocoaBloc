//
//  SBClient.h
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SBUser.h"
#import "SBAccount.h"

/// @name Globals

/// API method parameter dictionary keys
extern NSString *SBAPIMethodParameterResultLimit;
extern NSString *SBAPIMethodParameterResultOffset;

/// Fan club tier info dictionary keys
extern NSString *SBFanClubTierInfoName;
extern NSString *SBFanClubTierInfoCanSubmitContent;
extern NSString *SBFanClubTierInfoPrice;
extern NSString *SBFanClubTierInfoDescription;

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
 @param birthDate 	the user's birth date
 
 @return A "cold" signal that will perform the sign up upon subscription.
 		 The subscribed signal will send a "next" value
		 of the newly authenticated user (SBUser).
 */
- (RACSignal *)signUpWithEmail:(NSString *)email
					  password:(NSString *)password
					 birthDate:(NSDate *)birthDate __attribute__((unavailable("Not implemented in v1 yet")));


/// @name User

/*!
 Request the currently authenticated user from StageBloc.
 NOTE: This is already done on sign in. See the `user` property.
 
 @return A "cold" signal that will perform the request upon subscription.
 		 The subscribed signal will send a "next" value of the currently
	     authenticated user's SBUser object. This is the same as the `user` 
 		 property after signing in.
 */
- (RACSignal *)getMe;

/*!
 Request the StageBloc user by their user id.
 
 @param userID the user id of the user to be requested
 
 @return A "cold" signal that will perform the request upon subscription.
 The subscribed signal will send a "next" value of the requested
 user's representative SBUser object.
 */
- (RACSignal *)getUserWithID:(NSNumber *)userID;


/// @name Audio

/*!
 Request an uploaded audio track on StageBloc by its audio id.
 
 @param audioID 	the track's audio id
 @param account		the account to query for the track
 
 @return A "cold" signal that will perform the request upon subscription.
 		 The subscribed signal will send a "next" value of the 
         requested track's SBAudioUpload object.
 */
- (RACSignal *)getAudioTrackWithID:(NSNumber *)audioID
                        forAccount:(SBAccount *)account;

/*!
 
 */
- (RACSignal *)uploadAudioData:(NSData *)data
					 withTitle:(NSString *)title
                      fileName:(NSString *)fileName
                     toAccount:(SBAccount *)account
				progressSignal:(RACSignal **)progressSignal;


/// @name Fan Clubs

/*!
 Create the fan club for the given StageBloc account.
 
 @param account		the parent/fan-club-owning StageBloc account object
 @param title		the title for the fan club
 @param description	the description for the fan club
 @param tierInfo	a dictionary with any of the following tier info keys,
					or nil, to use the default values (determined server-side):
					SBFanClubTierInfoName
 					SBFanClubTierInfoCanSubmitContent
 					SBFanClubTierInfoPrice
 					SBFanClubTierInfoDescription
 
 @return A "cold" signal that will perform the creation upon subscription.
		 The subscribed signal will send a "next" value of the newly created
		 fan club object (SBFanClub).
 
 */
- (RACSignal *)createFanClubForAccount:(SBAccount *)account
								 title:(NSString *)title
						   description:(NSString *)description
							  tierInfo:(NSDictionary *)tierInfo;

/*!
 
 */
- (RACSignal *)getContentFromFanClubForAccount:(SBAccount *)account
									parameters:(NSDictionary *)parameters;

/*!
 
 */
- (RACSignal *)getRecentFanClubContentWithParameters:(NSDictionary *)parameters;


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
