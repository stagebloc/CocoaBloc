//
//  SBClient+User.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (User)

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

- (RACSignal *)resetUserPasswordForEmail:(NSString *)emailAddress;

@end
