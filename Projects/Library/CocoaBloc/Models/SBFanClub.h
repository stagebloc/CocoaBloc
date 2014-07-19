//
//  SBFanClub.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBFanClub : SBObject <MTLJSONSerializing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *canPostBlogs;
@property (nonatomic, strong) NSNumber *canPostPhotos;
@property (nonatomic, strong) NSNumber *canPostStatuses;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic, strong, getter = isModerated) NSNumber *moderated;
@property (nonatomic, strong) NSNumber *userTier;
@property (nonatomic, strong) NSArray *tiers;

@end
