//
//  SBAccount.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import "SBPhoto.h"

@interface SBAccount : SBObject <MTLJSONSerializing>

@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSNumber *verified;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *stageblocURL;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic) NSNumber *stripeEnabled;

@property (nonatomic) SBPhoto *photo;

@end
