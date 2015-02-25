//
//  RACSignal+JSONDeserialization.h
//  CocoaBloc
//
//  Created by John Heaton on 10/7/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "RACSignal.h"

@class SBClient;

@interface RACSignal (JSONDeserialization)

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client keyPath:(NSString *)keyPath modelClass:(Class)modelClass;
- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath modelClass:(Class)modelClass;

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client keyPath:(NSString *)keyPath;
- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath;

@end
