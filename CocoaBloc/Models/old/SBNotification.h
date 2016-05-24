//
//  SBNotification.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@class SBAccount, SBClient;

@interface SBNotification : SBObject <MTLJSONSerializing>

@property (nonatomic) NSDate *creationDate;
@property (nonatomic, copy) NSString *HTMLText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *route;

@property (nonatomic) SBAccount *account;
@property (nonatomic) NSNumber *accountID;

@end
