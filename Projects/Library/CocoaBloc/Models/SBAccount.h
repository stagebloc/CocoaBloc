//
//  SBAccount.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBAccount : SBObject <MTLJSONSerializing>//, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *verified;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *stageblocURL;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *URL;

@end
