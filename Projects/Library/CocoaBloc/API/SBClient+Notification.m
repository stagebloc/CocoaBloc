//
//  SBClient+Notification.m
//  CocoaBloc
//
//  Created by John Heaton on 1/6/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBClient+Notification.h"
#import <RACAFNetworking.h>
#import "SBClient+Private.h"
#import "SBClient.h"
#import "RACSignal+JSONDeserialization.h"
#import "SBNotification.h"

@implementation SBClient (Notification)

- (RACSignal *)getNotificationsForAccount:(SBAccount *)accountOrNil parameters:(NSDictionary *)parameters {
    NSMutableDictionary *p = (NSMutableDictionary *)parameters;
    if (accountOrNil != nil) {
        (p = p.mutableCopy)[@"account_id"] = accountOrNil.identifier;
    }
    
    return [[[[self rac_GET:@"users/me/notifications" parameters:[self requestParametersWithParameters:p]]
                map:^id(NSDictionary *response) {
                    return @{@"data" : response[@"data"][@"notifications"]};
                }]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get notifications (account: %@)", accountOrNil];
}

@end
