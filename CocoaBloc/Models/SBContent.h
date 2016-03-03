//
//  SBContent.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContentStreamObject.h"

NS_ASSUME_NONNULL_BEGIN

@class SBUser, SBAccount, SBClient;

@interface SBContent : SBContentStreamObject <MTLJSONSerializing>

@property (nonatomic) NSNumber *inModeration;
@property (nonatomic) NSNumber *isFanContent;

@property (nonatomic) NSNumber *authorUserID;

@property (nonatomic, nullable) SBUser *authorUser;

@end

NS_ASSUME_NONNULL_END
