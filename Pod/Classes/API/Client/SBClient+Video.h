//
//  SBClient+Video.h
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBVideo.h"

NSString static *const kVideoEventTypePlay = @"play";
NSString static *const kVideoEventTypeEnded = @"ended";
NSString static *const kVideoEventTypeLoop = @"loop";

@interface SBClient (Video)

/// @name Video

/*!
 Upload a video to an account.
 
 @param videoData       Valid video data.
 @param fileName        The path or name of the video file. MIME type is derived from this.
 @param account         The account to post to.
 @param progressSignal  A pointer to be filled with a cold signal, to which you may subscribe for progress value updates.
 */
- (RACSignal *)uploadVideoWithData:(NSData *)videoData
                          fileName:(NSString *)fileName
                             title:(NSString *)title
                           caption:(NSString *)caption
           toAccountWithIdentifier:(NSNumber *)accountIdentifier
                         exclusive:(BOOL)exclusive
                        fanContent:(BOOL)fanContent
                    progressSignal:(RACSignal **)progressSignal
                        parameters:(NSDictionary *)parameters;

/*!
 Upload a video directly from disk by providing the absolute path to the video file.
 */
- (RACSignal *)uploadVideoAtPath:(NSString *)filePath
                           title:(NSString *)title
                         caption:(NSString *)caption
         toAccountWithIdentifier:(NSNumber *)accountIdentifier
                       exclusive:(BOOL)exclusive
                      fanContent:(BOOL)fanContent
                  progressSignal:(RACSignal **)progressSignal
                      parameters:(NSDictionary *)parameters;

/*!
 Track video events.
 @param event           video event, supported events -> (play, ended, loop)
 @param videoID         The account to post to.
 @param accountID       The video of the associated event
 */
- (RACSignal *)trackVideoEvent:(NSString *)event
               videoIdentifier:(NSNumber *)videoIdentifier
             accountIdentifier:(NSNumber *)accountIdentifier;

@end
