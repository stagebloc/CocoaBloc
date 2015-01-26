//
//  SBClient+Push.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/26/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Push)

- (RACSignal *)setPushTokenForAuthenticatedUser:(NSString*)token;

@end
