//
//  SBClient+Video.h
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

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
                         toAccount:(SBAccount *)account
                    progressSignal:(RACSignal **)progressSignal;

/*!
 Upload a video directly from disk by providing the absolute path to the video file.
 */
- (RACSignal *)uploadVideoAtPath:(NSString *)filePath
                       toAccount:(SBAccount *)account
                  progressSignal:(RACSignal **)progressSignal;

@end
