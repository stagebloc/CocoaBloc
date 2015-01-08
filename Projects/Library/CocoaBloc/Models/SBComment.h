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
#import <RACCommand.h>

@interface SBComment : SBObject <MTLJSONSerializing>

@property (nonatomic) SBContent *content;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *replyCount;
@property (nonatomic) NSNumber *parentCommentID;
@property (nonatomic) NSURL *shortURL;
@property (nonatomic, copy) NSString *text;

@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *accountID;

- (RACSignal *)getUser;
- (RACSignal *)getAccount;

@end
