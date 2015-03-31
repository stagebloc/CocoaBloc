//
//  SBClient+Notification.h
//  CocoaBloc
//
//  Created by John Heaton on 1/6/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Notification)

/*!
 Gets all notifications for a user, optionally limiting result relevancy to a specific account of the user.
 
 @param parameters Accepted values: SBAPIMethodParameterResultLimit, SBAPIMethodParameterResultOffset
 */
- (RACSignal *)getNotificationsForAccountWithIdentifier:(NSNumber *)accountIdentifierOrNil parameters:(NSDictionary *)parameters;

@end
