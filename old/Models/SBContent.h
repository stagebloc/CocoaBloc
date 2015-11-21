//
//  SBContent.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@class SBUser, SBAccount, SBClient;

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

@end
