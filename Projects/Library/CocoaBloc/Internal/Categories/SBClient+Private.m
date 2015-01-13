//
//  SBClient+Private.m
//  CocoaBloc
//
//  Created by John Heaton on 10/15/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Private.h"
#import "SBClient+Auth.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>

extern NSString *SBClientID;

@implementation SBClient (Private)

- (NSDictionary *)requestParametersWithParameters:(NSDictionary *)parameters {
    NSMutableDictionary *p = parameters.mutableCopy ?: [NSMutableDictionary new];
    
    // Add client_id if not authenticated
    if (!self.authenticated) {
        p[@"client_id"] = SBClientID;
    }
    
    NSString *expanded;
    if ((expanded = p[@"expand"]) != nil) {
        // if expands exist already, add kind on (if needed)
        if (![expanded containsString:@"kind"]) {
            p[@"expand"] = [expanded stringByAppendingString:@",kind"];
        }
    } else {
        p[@"expand"] = @"kind";
    }
    
    return p;
}

@end
