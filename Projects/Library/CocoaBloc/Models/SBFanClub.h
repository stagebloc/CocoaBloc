//
//  SBFanClub.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBFanClub : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *canPostBlogs;
@property (nonatomic) NSNumber *canPostPhotos;
@property (nonatomic) NSNumber *canPostStatuses;
@property (nonatomic) NSNumber *userTier;
@property (nonatomic, getter = isModerated) NSNumber *moderated;
@property (nonatomic) NSArray *tiers;

@end
