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

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client modelClass:(Class)modelClass keyPath:(NSString *)keyPath {
    @weakify(client);
    
    return [[self flattenMap:^RACStream *(NSDictionary *response) {
        @strongify(client);
        
        return [client deserializeModelOfClass:modelClass fromJSONDictionary:!keyPath ? response : [response valueForKeyPath:keyPath]];
    }] take:1];
}

- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client modelClass:(Class)modelClass keyPath:(NSString *)keyPath {
    @weakify(client);
    
    return [[self flattenMap:^RACStream *(NSDictionary *response) {
        @strongify(client);
        
        NSMutableArray *signals = [NSMutableArray new];
        for (NSDictionary *item in !keyPath ? response : [response valueForKeyPath:keyPath]) {
            [signals addObject:[[RACSignal return:item] cb_deserializeWithClient:client modelClass:modelClass keyPath:nil]];
        }
        return [[[RACSignal combineLatest:signals] take:1] map:^id (RACTuple *models) {
            return models.allObjects;
        }];
    }] take:1];
}

- (RACSignal *)cb_deserializeContentArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath {
    @weakify(client);
    
    return [[self flattenMap:^RACStream *(NSDictionary *response) {
        @strongify(client);
        
        NSMutableArray *signals = [NSMutableArray new];
        for (NSDictionary *item in !keyPath ? response : [response valueForKeyPath:keyPath]) {
            Class modelClass = [SBContent modelClassForJSONContentType:item[@"content_type"]];
            if (modelClass != nil) {
                [signals addObject:[[RACSignal return:item] cb_deserializeWithClient:client modelClass:modelClass keyPath:nil]];
            }
        }
        return [[[RACSignal combineLatest:signals] take:1] map:^id (RACTuple *models) {
            return models.allObjects;
        }];
    }] take:1];
}

@end
