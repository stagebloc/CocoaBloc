//
//  SBContent.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAccount.h"
#import "SBUser.h"

@interface SBContent : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *excerpt;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *publishDate;
@property (nonatomic, strong) NSNumber *inModeration;
@property (nonatomic, strong) NSNumber *userHasLiked;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSURL *shortURL;

@property (nonatomic, strong) SBAccount *account;
@property (nonatomic, strong) SBUser *author;

@end
