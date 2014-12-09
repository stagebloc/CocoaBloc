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

- (RACSignal *)cb_deserializeWithClient:(SBClient *)client modelClass:(Class)modelClass keyPath:(NSString *)keyPath;
- (RACSignal *)cb_deserializeArrayWithClient:(SBClient *)client modelClass:(Class)modelClass keyPath:(NSString *)keyPath;
- (RACSignal *)cb_deserializeContentArrayWithClient:(SBClient *)client keyPath:(NSString *)keyPath;

@end
