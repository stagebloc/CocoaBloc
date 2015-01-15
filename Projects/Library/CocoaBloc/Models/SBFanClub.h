//
//  SBFanClub.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@class SBTier;

@interface SBFanClub : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *canPostBlogs;
@property (nonatomic) NSNumber *canPostPhotos;
@property (nonatomic) NSNumber *canPostStatuses;
@property (nonatomic) NSNumber *canPostAudio;
@property (nonatomic) NSNumber *canPostVideos;
@property (nonatomic) NSNumber *userTier;
@property (nonatomic) NSNumber *moderated;

@property (nonatomic) SBTier *tierOne;
@property (nonatomic) SBTier *tierTwo;
@property (nonatomic) SBTier *tierThree;

@end
