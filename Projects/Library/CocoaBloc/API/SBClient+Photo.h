//
//  SBClient+Photo.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Photo)

/*!
 Get a single SBPhoto, given its identifier and the associated account.
 */
- (RACSignal *)getPhotoWithID:(NSNumber *)photoID forAccount:(SBAccount *)account;

@end
