//
//  SBClient+Audio.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Audio)

/// @name Audio

/*!
 Request an uploaded audio track on StageBloc by its audio id.
 
 @param audioID 	the track's audio id
 @param account		the account to query for the track
 
 @return A "cold" signal that will perform the request upon subscription.
 The subscribed signal will send a "next" value of the
 requested track's SBAudioUpload object.
 */
- (RACSignal *)getAudioTrackWithID:(NSNumber *)audioID forAccountWithIdentifier:(NSNumber *)accountIdentifier;

/*!
 
 */
- (RACSignal *)uploadAudioData:(NSData *)data
                     withTitle:(NSString *)title
                      fileName:(NSString *)fileName
                     toAccount:(SBAccount *)account
                progressSignal:(RACSignal **)progressSignal;


@end
