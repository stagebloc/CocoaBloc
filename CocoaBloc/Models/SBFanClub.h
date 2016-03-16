//
//  SBFanClub.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@class SBTier, SBAccount, SBClient;

NS_ASSUME_NONNULL_BEGIN

@interface SBFanClub : SBObject <MTLJSONSerializing>

//`identifier` is not guaranteed to be set.

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *moderated; // Bool
@property (nonatomic) NSNumber *accountID;

@property (nonatomic) NSNumber *canPostBlogs; // Bool
@property (nonatomic) NSNumber *canPostPhotos; // Bool
@property (nonatomic) NSNumber *canPostStatuses; // Bool
@property (nonatomic) NSNumber *canPostAudio; // Bool
@property (nonatomic) NSNumber *canPostVideos; // Bool

// TODO(danzimm): PHP has this as present for legacy reasons. Switch over to using `user_membership`
@property (nonatomic, nullable) NSNumber *userTier;

// TODO(danzimm): This is an dictionary of n objects, there may or may not be tier 1,2,3
@property (nonatomic, nullable) SBTier *tierOne;
@property (nonatomic, nullable) SBTier *tierTwo;
@property (nonatomic, nullable) SBTier *tierThree;

/*!May or may not be nil, use `fetchAccount` for assurance.*/
@property (nonatomic, strong) SBAccount *account;

@end

NS_ASSUME_NONNULL_END
