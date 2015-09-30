//
//  SBUser.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import "SBPhoto.h"

#if TARGET_OS_IPHONE
@class UIColor;
#define SBUserColor UIColor
#else
@class NSColor;
#define SBUserColor NSColor
#endif

@interface SBUser : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSDate *birthday;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSDate *creationDate;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) SBUserColor *color;
@property (nonatomic) SBPhoto *photo;

@property (nonatomic) NSArray *adminAccounts;

@end
