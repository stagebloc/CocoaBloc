//
//  SBUser.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBObject.h"
#import "SBUserPhoto.h"
#import "SBUserColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBUser : SBObject <MTLJSONSerializing>

// Nil if -[NSURL URLWithString:] fails
@property (nonatomic, copy, nullable) NSURL *URL;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic) SBUserColor *color;

// nonnull if currently signed in user is this user
@property (nonatomic, nullable) NSDate *birthday;
@property (nonatomic, copy, nullable) NSString *emailAddress;
@property (nonatomic, copy, nullable) NSString *gender;

@property (nonatomic, nullable) SBUserPhoto *photo;

@end

NS_ASSUME_NONNULL_END
