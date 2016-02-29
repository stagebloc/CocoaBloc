//
//  SBContent.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

NS_ASSUME_NONNULL_BEGIN

@class SBUser, SBAccount, SBClient;

@interface SBContent : SBObject <MTLJSONSerializing>

+ (NSString *)URLPathContentType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *isFanContent;
@property (nonatomic) NSNumber *userHasLiked;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *commentCount;
// This will be nil if +[NSURL URLWithString:] fails
@property (nonatomic, nullable) NSURL *shortURL;

@property (nonatomic) NSNumber *accountID;
@property (nonatomic) NSNumber *authorUserID;

@property (nonatomic, nullable) SBAccount *account;
@property (nonatomic, nullable) SBUser *authorUser;

@end

NS_ASSUME_NONNULL_END
