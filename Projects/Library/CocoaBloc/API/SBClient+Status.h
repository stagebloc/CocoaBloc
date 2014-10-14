//
//  SBClient+Status.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBStatus.h"

@interface SBClient (Status)

- (RACSignal *)getStatusWithID:(NSNumber *)statusID;
- (RACSignal *)getUsersLikingStatus:(SBStatus *)status;
- (RACSignal *)deleteStatus:(SBStatus *)status;

@end
