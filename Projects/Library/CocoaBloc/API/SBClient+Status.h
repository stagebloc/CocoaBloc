//
//  SBClient+Status.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import <CoreLocation/CoreLocation.h>

@interface SBClient (Status)

/*!
 Post status to account. Convenience method for posting statuses
 */
- (RACSignal *)postStatus:(NSString *)status toAccountWithIdentifier:(NSNumber*)accountIdentifier fanContent:(BOOL)fanContent;

/*!
 Post status to account.
 */
- (RACSignal *)postStatus:(NSString *)status
  toAccountWithIdentifier:(NSNumber*)accountIdentifier
               fanContent:(BOOL)fanContent
                 latitude:(NSNumber*)latitude
                longitude:(NSNumber*)longitude;

@end
