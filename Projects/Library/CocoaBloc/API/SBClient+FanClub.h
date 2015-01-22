//
//  SBClient+FanClub.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (FanClub)

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
- (RACSignal *)createFanClubForAccountIdentifier:(NSNumber *)accountIdentifier
                                 title:(NSString *)title
                           description:(NSString *)description
                              tierInfo:(NSDictionary *)tierInfo;

/*!
 
 */
- (RACSignal *)getContentFromFanClubForAccount:(SBAccount *)account
                                    parameters:(NSDictionary *)parameters;

/*!
 Retrieves the content for fan clubs that the user follows.
 */
- (RACSignal *)getContentFromFollowedFanClubsWithParameters:(NSDictionary *)parameters;

/*!
 Retrieves the user's fan club following list.
 */
- (RACSignal*)getFollowedFanClubsWithParameters:(NSDictionary*)parameters;

/*! Retrieves the user's recent fan clubs list. */
- (RACSignal*)getRecentFanClubsWithParameters:(NSDictionary*)parameters;

/*! Retrieves the user's featured fan clubs list. */
- (RACSignal*)getFeaturedFanClubsWithParameters:(NSDictionary*)parameters;

/*!
 Retrieves the fan club details for the account.
 */
- (RACSignal*)getFanClubForAccountIdentifier:(NSNumber*)accountIdentifier parameters:(NSDictionary *)parameters;

@end
