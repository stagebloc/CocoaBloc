//
//  SBFanClubDashboard.h
//  CocoaBloc
//
//  Created by Mark Glagola on 3/10/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBObject.h"

@interface SBFanClubDashboardTier : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *totalFans;

@end

@interface SBFanClubDashboard : SBObject

@property (nonatomic) NSNumber *totalComments;
@property (nonatomic) NSNumber *totalFans;
@property (nonatomic) NSNumber *totalLikes;
@property (nonatomic) NSNumber *totalPosts;

//Genders
@property (nonatomic) NSNumber *totalMales;
@property (nonatomic) NSNumber *totalFemales;
@property (nonatomic) NSNumber *totalUnknown;

//Tiers
@property (nonatomic) SBFanClubDashboardTier *tierOne;
@property (nonatomic) SBFanClubDashboardTier *tierTwo;
@property (nonatomic) SBFanClubDashboardTier *tierThree;

@end
