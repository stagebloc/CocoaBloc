//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBClient+Auth.h"
#import "SBAudio.h"

#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import <ReactiveCocoa/RACEXTScope.h>

NSString *SBAPIMethodParameterResultLimit = @"limit";
NSString *SBAPIMethodParameterResultOffset = @"offset";
NSString *SBAPIMethodParameterResultDirection = @"direction";
NSString *SBAPIMethodParameterResultOrderBy = @"order_by";
NSString *SBAPIMethodParameterResultExpandedProperties = @"expand";

NSString *SBAPIErrorResponseObjectKey = @"SBAPIErrorResponseObjectKey";
NSString *SBCocoaBlocErrorDomain = @"SBCocoaBlocErrorDomain";

extern NSString *SBClientID, *SBClientSecret; // defined in +Auth.m

@interface SBClientResponseSerializer : AFJSONResponseSerializer @end
@implementation SBClientResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    id obj = [super responseObjectForResponse:response data:data error:error];
    if (*error != nil && obj != nil) {
        NSMutableDictionary *userInfo = (*error).userInfo.mutableCopy;
        userInfo[SBAPIErrorResponseObjectKey] = obj;
        
        *error = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
    }
    return obj;
}

@end

@implementation SBClient

@dynamic authenticatedUser;

- (id)init {
    if (!SBClientID.length || !SBClientSecret.length) {
        [NSException raise:@"CocoaBlocMissingClientIDSecretException" format:@"You may not use SBClient until you have set the current app's client id/secret with +[SBClient setClientID:clientSecret:]"];
        return nil;
    }
    
    BOOL cppDebug
#ifdef DEBUG
    = YES;
#else
    = NO;
#endif
    
    NSString *ext = @"com";
    if ([NSProcessInfo processInfo].environment[@"SB_LOCAL_DEV"] && cppDebug) { // enforce .com on release builds
    	ext = @"dev";
    }
    NSString *urlString = [NSString stringWithFormat:@"https://api.stagebloc.%@/v1", ext];
    
    self = [super initWithBaseURL:[NSURL URLWithString:urlString]];
    if (self) {
        self.responseSerializer = [SBClientResponseSerializer serializer];
        self.deserializationScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
#ifdef DEBUG
        self.securityPolicy.allowInvalidCertificates = YES; // dave says this is a dragon's leash
#endif
    }
    
    return self;
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
    return [self enqueueRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
}

- (RACSignal *)enqueueRequestOperation:(AFHTTPRequestOperation *)operation {
    return [RACSignal defer:^RACSignal *{
        return [self rac_enqueueHTTPRequestOperation:operation];
    }];
}

- (RACSignal *)deserializeModelFromJSONDictionary:(NSDictionary *)dictionary {
    NSParameterAssert(dictionary);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [self.deserializationScheduler schedule:^{
            NSError *error;
            id model = [MTLJSONAdapter modelOfClass:[SBObject class]
                                 fromJSONDictionary:dictionary
                                              error:&error];
            
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }
        }];
    }] setNameWithFormat:@"JSON Deserialization"];
}

@end
