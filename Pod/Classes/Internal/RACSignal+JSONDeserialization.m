//
//  RACSignal+JSONDeserialization.m
//  CocoaBloc
//
//  Created by John Heaton on 10/7/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "RACSignal+JSONDeserialization.h"
#import "SBClient.h"
#import <ReactiveCocoa/RACEXTScope.h>

@implementation RACSignal (JSONDeserialization)

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client keyPath:(NSString *)keyPath modelClass:(Class)modelClass {
    @weakify(client);
    
    return [self flattenMap:^RACStream *(RACTuple *responseObjectAndResponse) {
        @strongify(client);
        
        NSDictionary *object = responseObjectAndResponse.first;
        return [client deserializeModelFromJSONDictionary:!keyPath ? object : [object valueForKeyPath:keyPath] modelClass:modelClass];
    }];

}

- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath modelClass:(Class)modelClass {
    @weakify(client);
    
    return [self flattenMap:^RACStream *(RACTuple *responseObjectAndResponse) {
        @strongify(client);
        
        NSDictionary *object = responseObjectAndResponse.first;
        return [client deserializeModelsFromJSONArray:!keyPath ? object : [object valueForKeyPath:keyPath] modelClass:modelClass];
    }];
}

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client keyPath:(NSString *)keyPath {
    return [self cb_deserializeWithClient:client keyPath:keyPath modelClass:[SBObject class]];
}

- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath {
    return [self cb_deserializeArrayWithClient:client keyPath:keyPath modelClass:[SBObject class]];
}

@end
