//
//  SBClient+Status.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Status.h"
#import "SBClient+Private.h"
#import <RACAFNetworking.h>
#import "RACSignal+JSONDeserialization.h"
#import "SBStatus.h"

@implementation SBClient (Status)

- (RACSignal *)postStatus:(NSString *)status toAccountWithIdentifier:(NSNumber *)accountIdentifier fanContent:(BOOL)fanContent {
    return [self postStatus:status toAccountWithIdentifier:accountIdentifier fanContent:fanContent latitude:nil longitude:nil];
}

- (RACSignal *)postStatus:(NSString *)status
  toAccountWithIdentifier:(NSNumber *)accountIdentifier
               fanContent:(BOOL)fanContent
                 latitude:(NSNumber *)latitude
                longitude:(NSNumber *)longitude {
    NSParameterAssert(status);
    NSParameterAssert(accountIdentifier);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[status, @(fanContent)] forKeys:@[@"text", SBAPIMethodParameterResultFanContent]];
    
    if (latitude && longitude) {
        [params setObject:latitude forKey:@"latitude"];
        [params setObject:longitude forKey:@"longitude"];
    }
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/status", accountIdentifier] parameters:[self requestParametersWithParameters:params]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Post status (%@) to account %@", status, accountIdentifier];
}

@end
