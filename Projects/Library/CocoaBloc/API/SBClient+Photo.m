//
//  SBClient+Photo.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Photo.h"
#import <RACAFNetworking.h>
#import "SBClient+Private.h"
#import "RACSignal+JSONDeserialization.h"

@implementation SBClient (Photo)

- (RACSignal *)getPhotoWithID:(NSNumber *)photoID forAccount:(SBAccount *)account {
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/photo/%@", account.identifier, photoID] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get photo (id: %@, accountID: %@)", photoID, account.identifier];
}

@end
