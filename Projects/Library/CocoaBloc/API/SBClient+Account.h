//
//  SBClient+Account.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Account)

/// @methodgroup Account

/*!
 Get an account based on an account ID.
 
 @return a cold signal that will perform the request on subscription.
 */
- (RACSignal *)getAccountWithID:(NSNumber *)accountID;

/*!
 Update an account with one or more new properties.
 NOTE: Only admins of the account are allowed to do this.
 
 @param name the new account name, or nil
 @param description the new account description, or nil
 @param urlString the new StageBloc URL path component for the account, or nil
 
 @return 	a cold signal that will perform the request on subscription,
            or nil if all of the parameters are nil.
 */
- (RACSignal *)updateAccount:(SBAccount *)account
                        name:(NSString *)name
                 description:(NSString *)description
                stageBlocURL:(NSString *)urlString;

/*!
 Get an activity stream of recent content for an account.
 */
- (RACSignal *)getActivityStreamForAccount:(SBAccount *)account parameters:(NSDictionary*)parameters;

/*!
 
 @param accountId the ID of the parent account
 @param type a specific type of child account to get (optional)
 */
- (RACSignal *)getChildrenAccountsForAccount:(NSNumber *)accountId withType:(NSString *)type;

@end
