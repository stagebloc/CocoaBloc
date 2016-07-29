//
//  SBComment.h
//  CocoaBloc
//
//  Created by John Heaton on 12/10/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBObject.h"
#import "SBAccount.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SBUser;

@interface SBComment : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSNumber *parentCommentID; // Int
@property (nonatomic) NSNumber *replyCount; // Int
@property (nonatomic) NSURL *shortURL;
@property (nonatomic) NSNumber *inModeration; // Bool
@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *accountID;

@property (nonatomic, nullable) SBContentStreamObject *content;
@property (nonatomic, nullable) SBUser *user;
@property (nonatomic, nullable) SBAccount *account;

@end

NS_ASSUME_NONNULL_END
