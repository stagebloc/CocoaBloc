//
//  SBStoreDashboard.h
//  CocoaBloc
//
//  Created by Mark Glagola on 3/9/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBObject.h"

@class SBUser;

@interface SBStoreDashboardAverages : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *totalOrders;
@property (nonatomic) NSNumber *totalRevenue;

@end

@interface SBStoreDashboardTopBuyers : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *amountSpent;
@property (nonatomic) SBUser *user;

@end

@interface SBStoreDashboard : SBObject <MTLJSONSerializing>

@property (nonatomic) NSNumber *averageFanValue;
@property (nonatomic) NSNumber *averageOrderPrice;

@property (nonatomic) NSNumber *fanClubRevenue;
@property (nonatomic) NSNumber *storeRevenue;

@property (nonatomic) NSNumber *totalOrders;
@property (nonatomic) NSNumber *totalRevenue;
@property (nonatomic) NSNumber *totalShippingHandling;
@property (nonatomic) NSNumber *totalTaxes;

@property (nonatomic) NSDictionary *countries;
@property (nonatomic) NSArray *topBuyers;

@end

