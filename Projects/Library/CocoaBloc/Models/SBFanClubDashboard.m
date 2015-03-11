//
//  SBFanClubDashboard.m
//  CocoaBloc
//
//  Created by Mark Glagola on 3/10/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBFanClubDashboard.h"
#import <MTLValueTransformer.h>
#import <NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"

@implementation SBFanClubDashboardTier

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name"        : @"name",
             @"totalFans"   : @"fans",
             };
}

@end

@implementation SBFanClubDashboard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"totalComments"      : @"totals.comments",
              @"totalFans"          : @"totals.fans",
              @"totalLikes"         : @"totals.likes",
              @"totalPosts"         : @"totals.posts",
              @"totalMales"         : @"totals.gender.male",
              @"totalFemales"       : @"totals.gender.female",
              @"totalUnknown"       : @"totals.gender.unknown",
              @"tierOne"            : @"totals.tiers.1",
              @"tierTwo"            : @"totals.tiers.2",
              @"tierThree"          : @"totals.tiers.3",
              }];
}

+ (MTLValueTransformer *)tierOneJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^SBFanClubDashboardTier *(NSDictionary *dictionary) {
        return [MTLJSONAdapter modelOfClass:[SBFanClubDashboardTier class] fromJSONDictionary:dictionary error:nil];
    } reverseBlock:^NSDictionary *(SBFanClubDashboardTier *obj) {
        return [MTLJSONAdapter JSONDictionaryFromModel:obj];
    }];
}

+ (MTLValueTransformer *)tierTwoJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^SBFanClubDashboardTier *(NSDictionary *dictionary) {
        return [MTLJSONAdapter modelOfClass:[SBFanClubDashboardTier class] fromJSONDictionary:dictionary error:nil];
    } reverseBlock:^NSDictionary *(SBFanClubDashboardTier *obj) {
        return [MTLJSONAdapter JSONDictionaryFromModel:obj];
    }];
}

+ (MTLValueTransformer *)tierThreeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^SBFanClubDashboardTier *(NSDictionary *dictionary) {
        return [MTLJSONAdapter modelOfClass:[SBFanClubDashboardTier class] fromJSONDictionary:dictionary error:nil];
    } reverseBlock:^NSDictionary *(SBFanClubDashboardTier *obj) {
        return [MTLJSONAdapter JSONDictionaryFromModel:obj];
    }];
}

@end
