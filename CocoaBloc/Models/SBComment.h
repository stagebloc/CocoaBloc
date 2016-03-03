//
//  SBComment.h
//  CocoaBloc
//
//  Created by John Heaton on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import "SBAccount.h"
#import <Foundation/Foundation.h>

@class SBUser;

@interface SBComment : SBObject <MTLJSONSerializing>

// TODO(danzimm): This isn't insync with the API
@property (nonatomic) SBContentStreamObject *content;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *replyCount;
@property (nonatomic) NSNumber *parentCommentID;
@property (nonatomic) NSURL *shortURL;
@property (nonatomic, copy) NSString *text;

@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *accountID;

@property (nonatomic) SBUser *user;
@property (nonatomic) SBAccount *account;

@end
