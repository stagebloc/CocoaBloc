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
extern NSString * const SBAPIMethodParameterResultLimit;                 // NSNumber
extern NSString * const SBAPIMethodParameterResultOffset;                // NSNumber
extern NSString * const SBAPIMethodParameterResultOrderBy;               // NSString "created" / "modified" / "price"
extern NSString * const SBAPIMethodParameterResultDirection;             // NSString "ASC" or "DESC"
extern NSString * const SBAPIMethodParameterResultExpandedProperties;    // NSString @"user", @"account", etc. No whitespace, and comma-separated string
extern NSString * const SBAPIMethodParameterResultFilter;                // NSString @"blog",@"blog,photos,statuses", etc. No whitespace, and comma-separated string
extern NSString * const SBAPIMethodParameterResultIncludeAdminAccounts;  // NSString @"true", @"false"
extern NSString * const SBAPIMethodParameterResultFanContent;            // NSNumber @YES, @NO



/*
 SBAPIMethodParameterFlagContent preset values which can be used for
 reasons why someone flagged a piece of `SBContent` or `SBComment`
 */
extern NSString * const SBAPIMethodParameterFlagContent;
extern NSString * const SBAPIMethodParameterFlagContentValueOffensive;
extern NSString * const SBAPIMethodParameterFlagContentValuePrejudice;
extern NSString * const SBAPIMethodParameterFlagContentValueCopyright;
extern NSString * const SBAPIMethodParameterFlagContentValueDuplicate;


// Error handling
extern NSString * const SBAPIErrorResponseObjectKey;			// Deserialized JSON object from server
extern NSString * const SBCocoaBlocErrorDomain;                // Error domain for CB-generated errors


// CocoaBloc error codes
typedef NS_ENUM(NSInteger, SBCocoaBlocErrorCode) {
    kSBCocoaBlocErrorInvalidFileNameOrMIMEType = 0
};

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

 @return A "cold" signal that will actually enqueue and start the request
 		 upon subscription. It will send a "next" value of the response object
 		 if successful, or the network error if not.
 */
- (RACSignal *)enqueueRequest:(NSURLRequest *)request;
- (RACSignal *)enqueueRequestOperation:(AFHTTPRequestOperation *)operation;

- (RACSignal *)deserializeModelsFromJSONArray:(NSArray *)array;
- (RACSignal *)deserializeModelFromJSONDictionary:(NSDictionary *)dictionary;

/// The scheduler on which work will be done when converting JSON data into models.
/// Default = background scheduler
@property (nonatomic) RACScheduler *deserializationScheduler;

@property (nonatomic, readonly) SBUser *authenticatedUser;

@end
