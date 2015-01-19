//
//  SBContent.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import <ReactiveCocoa/RACSignal.h>

@class SBUser, SBAccount, RACCommand;
@interface SBContent : SBObject <MTLJSONSerializing>

+ (NSString *)URLPathContentType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *excerpt;
@property (nonatomic) NSDate *modificationDate;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSDate *publishDate;
@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *isFanContent;
@property (nonatomic) NSNumber *userHasLiked;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *isSticky;
@property (nonatomic) NSNumber *isExclusive;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSURL *shortURL;

@property (nonatomic) NSNumber *accountID;
@property (nonatomic) NSNumber *authorUserID;

@property (nonatomic) SBAccount *account;
@property (nonatomic) SBUser *authorUser;

@property (nonatomic, readonly) RACCommand *fetchAccountCommand;
@property (nonatomic, readonly) RACCommand *fetchAuthorUserCommand;

/*! Executes `fetchAccountCommand` with a new SBClient instance */
- (RACSignal *)fetchAccount;

/*! Executes `fetchAuthorUserCommand` with a new SBClient instance */
- (RACSignal *)fetchAuthorUser;

@end
