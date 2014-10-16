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
    return self.authenticated ? parameters : [(parameters ?: @{}) mtl_dictionaryByAddingEntriesFromDictionary:@{@"client_id":SBClientID}];
}

@end
