//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import <RACAFNetworking.h>

@implementation SBClient

static NSString *SBClientID, *SBClientSecret;
+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    SBClientID = clientID.copy;
    SBClientSecret = clientSecret.copy;
}

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.stagebloc.com/v1"]];
    if (self) {
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    
    return self;
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    return  [[[self rac_POST:@"oauth2/token"
            	parameters:@{@"grant_type"    : @"password",
                               @"username"      : username,
                               @"password"      : password,
                               @"include_admin_accounts" : @"1",
                               @"client_secret" : SBClientID,
                               @"client_id"     : SBClientSecret}]
        		doNext:^(NSDictionary *response) {
                	
                }]
            	setNameWithFormat:@"Log In"];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
	return [self rac_enqueueHTTPRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
}

@end
