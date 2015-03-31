//
//  RACSignal+JSONDeserialization.m
//  CocoaBloc
//
//  Created by John Heaton on 10/7/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "RACSignal+JSONDeserialization.h"
#import "SBClient.h"
#import <RACEXTScope.h>

@implementation RACSignal (JSONDeserialization)

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client keyPath:(NSString *)keyPath modelClass:(Class)modelClass {
    @weakify(client);
    
    return [self flattenMap:^RACStream *(NSDictionary *response) {
        @strongify(client);
        
        return [client deserializeModelFromJSONDictionary:!keyPath ? response : [response valueForKeyPath:keyPath] modelClass:modelClass];
    }];

}

- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath modelClass:(Class)modelClass {
    @weakify(client);
    
    return [self flattenMap:^RACStream *(NSDictionary *response) {
        @strongify(client);
        
        return [client deserializeModelsFromJSONArray:!keyPath ? response : [response valueForKeyPath:keyPath] modelClass:modelClass];
    }];

}

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client keyPath:(NSString *)keyPath {
    return [self cb_deserializeWithClient:client keyPath:keyPath modelClass:[SBObject class]];
}

- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath {
    return [self cb_deserializeArrayWithClient:client keyPath:keyPath modelClass:[SBObject class]];
}

@end
