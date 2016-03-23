//
//  SBAccount.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import "SBAccountPhoto.h"
#import "SBNotificationSettings.h"

#if TARGET_OS_IPHONE
@class UIColor;
#define SBUserColor UIColor
#else
@class NSColor;
#define SBUserColor NSColor
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SBAccount : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) NSString *stageblocURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) NSNumber *stripeEnabled;
@property (nonatomic) SBUserColor *color;
@property (nonatomic) NSNumber *verified;

@property (nonatomic, nullable) SBAccountPhoto *photo;

@property (nonatomic, nullable) NSNumber *userIsAdmin;
@property (nonatomic, nullable, copy) NSString *userRole;

@property (nonatomic, nullable) SBNotificationSettings *commentSettings;
@property (nonatomic, nullable) SBNotificationSettings *eventRSVPSettings;
@property (nonatomic, nullable) SBNotificationSettings *generalSettings;
@property (nonatomic, nullable) SBNotificationSettings *likeSettings;
@property (nonatomic, nullable) SBNotificationSettings *followSettings;

@end

NS_ASSUME_NONNULL_END