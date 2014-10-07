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

/*!
 Enqueue a network request with this client. Any configurations
 or authentications will be used for this request.
 
 @param request the network request to enqueue
 
 @return A "cold" signal that will actually enqueue and start the request
 		 upon subscription. It will send a "next" value of the response object
 		 if successful, or the network error if not.
 */
- (RACSignal *)enqueueRequest:(NSURLRequest *)request;

- (RACSignal *)deserializeModelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)dictionary;

/// The scheduler on which work will be done when converting JSON data into models.
/// Default = background scheduler
@property (nonatomic) RACScheduler *deserializationScheduler;

@end
