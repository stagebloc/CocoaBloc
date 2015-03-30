//
//  SBClient+Private.h
//  CocoaBloc
//
//  Created by John Heaton on 10/15/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Private)

- (NSDictionary *)requestParametersWithParameters:(NSDictionary *)parameters;

@end