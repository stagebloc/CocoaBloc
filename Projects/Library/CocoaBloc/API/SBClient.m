//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBClient+Auth.h"
#import "SBAudioUpload.h"

#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import <ReactiveCocoa/RACEXTScope.h>

NSString *SBAPIMethodParameterResultLimit = @"limit";
NSString *SBAPIMethodParameterResultOffset = @"offset";

@interface SBClient ()
@property (nonatomic, assign, readwrite) BOOL authenticated;
@property (nonatomic, copy, readwrite) NSString *token;
@end

@implementation SBClient

static NSString *SBClientID, *SBClientSecret; // defined in +Auth.m

- (id)init {
    if (!SBClientID.length || !SBClientSecret.length) {
        [NSException raise:@"CocoaBlocMissingClientIDSecretException" format:@"You may not use SBClient until you have set the current app's client id/secret with +[SBClient setClientID:clientSecret:]"];
        return nil;
    }
    
    self = [super initWithBaseURL:[NSURL URLWithString:
#ifdef DEBUG
                                   @"https://api.stagebloc.dev/v1"
#else
                                   @"https://api.stagebloc.com/v1"
#endif
                                   ]];
    if (self) {
        self.securityPolicy.allowInvalidCertificates = YES; // dave says this is a dragon's leash
    }
    
    return self;
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
    return [RACSignal defer:^RACSignal *{
        return [self rac_enqueueHTTPRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
    }];
}

@end
