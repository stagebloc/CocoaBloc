//
//  SBAudioUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBAudioUpload : SBObject <MTLJSONSerializing>

@property (nonatomic) NSNumber *postingAccountID;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic, copy) NSURL *editURL;
@property (nonatomic) NSNumber *exclusive;
@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSDate *modificationDate;
@property (nonatomic) NSURL *shortURL;
@property (nonatomic, getter = isSticky) NSNumber *sticky;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *userHasLiked;

@end
