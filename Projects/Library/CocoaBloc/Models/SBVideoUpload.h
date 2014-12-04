//
//  SBVideoUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBVideoUpload : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSURL *shortURL;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSDate *modificationDate;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *inFanContent;
@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *userHasLiked;

@end
