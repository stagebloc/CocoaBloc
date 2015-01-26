//
//  SBClient+Push.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/26/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBClient+Push.h"
#import "SBClient+Private.h"
#import <RACAFNetworking.h>
#import "RACSignal+JSONDeserialization.h"

@implementation SBClient (Push)

- (RACSignal *)setPushTokenForAuthenticatedUser:(NSString*)token {
    NSParameterAssert(token);
    
    NSDictionary *params = @{@"token":token};
    return [[self rac_POST:@"application/push/token" parameters:[self requestParametersWithParameters:params]]
                setNameWithFormat:@"Set push token for authenticated user"];
}

@end
