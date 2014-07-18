//
//  SBUser.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBUser : SBObject <MTLJSONSerializing>//, MTLManagedObjectSerializing>

@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *birthdateString;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *createdDateString;

@property (nonatomic, strong) NSArray *adminAccounts;

@end
