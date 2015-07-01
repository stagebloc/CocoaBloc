//
//  SBClient+User.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import <CoreLocation/CoreLocation.h>

extern NSString *SBClientUserProfileUpdateParameterBio;
extern NSString *SBClientUserProfileUpdateParameterBirthday;
extern NSString *SBClientUserProfileUpdateParameterEmailAddress;
extern NSString *SBClientUserProfileUpdateParameterUsername;
extern NSString *SBClientUserProfileUpdateParameterName;
extern NSString *SBClientUserProfileUpdateParameterGender;

extern NSString *SBUserContentListTypeUpdate;
extern NSString *SBUserContentListTypeLike;

@interface SBClient (User)

/// @name User

/*!
 Request the currently authenticated user for the SBClient.
 NOTE: 	This is already available on sign in. See the `authenticatedUser` property.
 		calling this method will update the property as well.
 
 @return A "cold" signal that will perform the request upon subscription.
 The subscribed signal will send a "next" value of the currently
 authenticated user's SBUser object. This is the same as the `authenticatedUser`
 property after signing in.
 */
- (RACSignal *)getCurrentlyAuthenticatedUser;

- (RACSignal *)updateAuthenticatedUserWithParameters:(NSDictionary *)parameters;
- (RACSignal *)updateAuthenticatedUserWithPhotoData:(NSData*)photoData progressSignal:(RACSignal**)progressSignal;
- (RACSignal *)updateAuthenticatedUserWithParameters:(NSDictionary *)parameters photoData:(NSData*)photoData photoProgressSignal:(RACSignal**)photoProgressSignal;

- (RACSignal *)sendPasswordResetToEmail:(NSString *)emailAddress;

- (RACSignal *)updateAuthenticatedUserLocationWithCoordinates:(CLLocationCoordinate2D)coordinates;

/*!
 Ban user from a particular account.

 @param userID of user to be banned
 @param accountID of account from which user should be banned
 @param reason a string detailing why user should be banned from the account

 */
-(RACSignal *)banUserWithID:(NSNumber *)userID
          fromAccountWithID:(NSNumber *)accountID
                     reason:(NSString*)reason;

/*!
 Request a list of content the user has either submitted or liked

 @param userID the user id of the user to be requested
 @param contentListType specifies either a list of user-submitted content ('SBUserContentListTypeUpdate')
 or user-liked content ('SBUserContentListTypeLike')

 @return A "cold" signal that will perform the request upon subscription.
 The subscribed signal will send a "next" value of an array of SBContent objects.
 */
- (RACSignal *)getPostedContentForUserID:(NSNumber *)userID
                         contentListType:(NSString *)contentListType
                              parameters:(NSDictionary*)parameters;

/*!
 Request the StageBloc user by their user id.
 
 @param userID the user id of the user to be requested
 
 @return A "cold" signal that will perform the request upon subscription.
 The subscribed signal will send a "next" value of the requested
 user's representative SBUser object.
 */
- (RACSignal *)getUserWithID:(NSNumber *)userID;


@end
