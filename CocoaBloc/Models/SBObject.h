//
//  SBObject.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBObject : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *identifier;
@property (nonatomic, copy, nullable) NSString *kind;

@end

NS_ASSUME_NONNULL_END