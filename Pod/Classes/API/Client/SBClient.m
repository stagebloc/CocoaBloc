//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "SBClient.h"
#import "SBClient+Auth.h"
#import "SBAudio.h"

NSString * const CocoaBlocMissingClientIDSecretException = @"CocoaBlocMissingClientIDSecretException";

NSString * const SBAPIMethodParameterResultLimit = @"limit";
NSString * const SBAPIMethodParameterResultOffset = @"offset";
NSString * const SBAPIMethodParameterResultDirection = @"direction";
NSString * const SBAPIMethodParameterResultOrderBy = @"order_by";
NSString * const SBAPIMethodParameterResultExpandedProperties = @"expand";
NSString * const SBAPIMethodParameterResultFilter = @"filter";
NSString * const SBAPIMethodParameterResultIncludeAdminAccounts = @"include_admin_accounts";
NSString * const SBAPIMethodParameterResultFanContent = @"fan_content";
NSString * const SBAPIMethodParameterResultFollowing = @"following";


NSString * const SBAPIErrorResponseObjectKey = @"SBAPIErrorResponseObjectKey";
NSString * const SBCocoaBlocErrorDomain = @"SBCocoaBlocErrorDomain";

/// Comment and Content flagging type
NSString * const SBAPIMethodParameterFlagContentValueOffensive = @"offensive";
NSString * const SBAPIMethodParameterFlagContentValuePrejudice = @"prejudice";
NSString * const SBAPIMethodParameterFlagContentValueCopyright = @"copyright";
NSString * const SBAPIMethodParameterFlagContentValueDuplicate = @"duplicate";

extern NSString *SBClientID, *SBClientSecret; // defined in +Auth.m

@interface SBClientResponseSerializer : AFJSONResponseSerializer @end
@implementation SBClientResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    id obj = [super responseObjectForResponse:response data:data error:error];
    if (*error != nil && obj != nil) {
        NSMutableDictionary *userInfo = (*error).userInfo.mutableCopy ?: [NSMutableDictionary new];
        userInfo[SBAPIErrorResponseObjectKey] = obj;
        userInfo[NSLocalizedFailureReasonErrorKey] = obj[@"metadata"][@"error"];
        
        *error = [NSError errorWithDomain:SBCocoaBlocErrorDomain code:(*error).code userInfo:userInfo];
    }
    return obj;
}

@end

@implementation SBClient

@dynamic authenticatedUser;

- (id)init {
    if (!SBClientID.length || !SBClientSecret.length) {
        [NSException raise:CocoaBlocMissingClientIDSecretException format:@"You may not use SBClient until you have set the current app's client id/secret with +[SBClient setClientID:clientSecret:]"];
        return nil;
    }
    
    BOOL cppDebug
#ifdef DEBUG
    = YES;
#else
    = NO;
#endif
    
    NSString *overrideString = nil;
    if (cppDebug) { // enforce .com on release builds
        overrideString = [NSProcessInfo processInfo].environment[@"SBClientBaseURLOverride"];
    }
    NSString *urlString = overrideString ?: [NSString stringWithFormat:@"https://api.stagebloc.com/v1"];
    
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

- (RACSignal *)deserializeModelsFromJSONArray:(NSArray *)array modelClass:(Class)modelClass {
    NSParameterAssert([array isKindOfClass:[NSArray class]]);
    
    return [[RACSignal startLazilyWithScheduler:self.deserializationScheduler block:^(id<RACSubscriber> subscriber) {
        NSError *error;
        id models = [MTLJSONAdapter modelsOfClass:modelClass
                                    fromJSONArray:array
                                            error:&error];
        
        if (error) {
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:models];
            [subscriber sendCompleted];
        }
    }] setNameWithFormat:@"JSON Array Deserialization"];

}

- (RACSignal *)deserializeModelFromJSONDictionary:(NSDictionary *)dictionary modelClass:(Class)modelClass {
    NSParameterAssert([dictionary isKindOfClass:[NSDictionary class]]);
    
    return [[RACSignal startLazilyWithScheduler:self.deserializationScheduler block:^(id<RACSubscriber> subscriber) {
        NSError *error;
        id model = [MTLJSONAdapter modelOfClass:modelClass
                             fromJSONDictionary:dictionary
                                          error:&error];
        
        if (error) {
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        }
    }] setNameWithFormat:@"JSON Dictionary Deserialization"];
}

@end
