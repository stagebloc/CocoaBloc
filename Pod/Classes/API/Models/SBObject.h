//
//  SBObject.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface SBObject : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *identifier;

@end
