//
//  SBAccount.h
//  CocoaBloc
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import "SBPhoto.h"
#import "SBNotificationSettings.h"

#if TARGET_OS_IPHONE
@class UIColor;
#define SBUserColor UIColor
#else
@class NSColor;
#define SBUserColor NSColor
#endif

@interface SBAccount : SBObject <MTLJSONSerializing>

@property (nonatomic) NSNumber *verified;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *stageblocURL;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic) NSNumber *stripeEnabled;
@property (nonatomic) NSNumber *userIsAdmin;
@property (nonatomic, copy) NSString *userRole;
@property (nonatomic, copy) SBUserColor *color;

@property (nonatomic) SBPhoto *photo;

@property (nonatomic) SBNotificationSettings *commentSettings;
@property (nonatomic) SBNotificationSettings *eventRSVPSettings;
@property (nonatomic) SBNotificationSettings *generalSettings;
@property (nonatomic) SBNotificationSettings *likeSettings;
@property (nonatomic) SBNotificationSettings *followSettings;

@end
