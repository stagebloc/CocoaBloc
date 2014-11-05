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
NSString *SBAPIMethodParameterResultDirection = @"direction";
NSString *SBAPIMethodParameterResultOrderBy = @"order_by";

extern NSString *SBClientID, *SBClientSecret; // defined in +Auth.m

@implementation SBClient

@dynamic authenticatedUser;

- (id)init {
    if (!SBClientID.length || !SBClientSecret.length) {
        [NSException raise:@"CocoaBlocMissingClientIDSecretException" format:@"You may not use SBClient until you have set the current app's client id/secret with +[SBClient setClientID:clientSecret:]"];
        return nil;
    }
    
    BOOL cppDebug = NO;
    
    NSString *ext = @"com";
    if ([NSProcessInfo processInfo].environment[@"SB_LOCAL_DEV"] && !cppDebug) { // enforce .com on release builds
    	ext = @"dev";
    }
    NSString *urlString = [NSString stringWithFormat:@"https://api.stagebloc.%@/v1", ext];
    
    self = [super initWithBaseURL:[NSURL URLWithString:urlString]];
    if (self) {
        self.deserializationScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
#ifdef DEBUG
        self.securityPolicy.allowInvalidCertificates = YES; // dave says this is a dragon's leash
#endif
    }
    
    return self;
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
    return [RACSignal defer:^RACSignal *{
        return [self rac_enqueueHTTPRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
    }];
}

- (RACSignal *)deserializeModelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)dictionary {
    NSParameterAssert(dictionary);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [self.deserializationScheduler schedule:^{
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
        }];
    }] setNameWithFormat:@"JSON Deserialization (Model class: %@)", NSStringFromClass(modelClass)];
}

@end
