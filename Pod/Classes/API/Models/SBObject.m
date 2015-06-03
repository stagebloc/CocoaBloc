//
//  SBObject.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import "SBComment.h"
#import "SBOrder.h"
#import "SBAddress.h"
#import "SBNotification.h"
#import "SBFanClub.h"
#import "SBAudio.h"
#import "SBVideo.h"
#import "SBStoreItem.h"
#import "SBBlog.h"
#import "SBStatus.h"
#import "SBPhoto.h"
#import "SBUser.h"
#import "SBAccount.h"
#import "SBTier.h"
#import "SBStoreDashboard.h"
#import "SBFanClubDashboard.h"
#import <MTLModel+NSCoding.h>

@implementation SBObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"identifier"  : @"id",
             @"kind"        : @"kind"};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    static NSDictionary *_kindModelMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _kindModelMap = @{ @"user"                              : [SBUser class],
                           @"user_photo"                        : [SBPhoto class],
                           @"account"                           : [SBAccount class],
                           @"fan_club"                          : [SBFanClub class],
                           @"fan_club_tier"                     : [SBTier class],
                           @"fan_club_dashboard"                : [SBFanClubDashboard class],
                           @"photo"                             : [SBPhoto class],
                           @"audio"                             : [SBAudio class],
                           @"blog"                              : [SBBlog class],
                           @"status"                            : [SBStatus class],
                           @"video"                             : [SBVideo class],
                           @"comment"                           : [SBComment class],
                           @"notification"                      : [SBNotification class],
                           @"order"                             : [SBOrder class],
                           @"address"                           : [SBAddress class],
                           @"store_item"                        : [SBStoreItem class],
                           @"store_item_option"                 : [SBStoreItemOption class],
                           @"store_item_shipping_price_handler" : [SBStoreItemPriceConfiguration class],
                           @"store_dashboard"                   : [SBStoreDashboard class],
                           };
    });
    
    return _kindModelMap[JSONDictionary[@"kind"]];
}

- (BOOL)isEqual:(id)object {
    __block BOOL equal = YES;
    NSArray *properties = [[[self class] JSONKeyPathsByPropertyKey] allKeys];
    [properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![object respondsToSelector:NSSelectorFromString(key)] || ![[object valueForKey:key] isEqual:[self valueForKey:key]]) {
            equal = NO;
            *stop = YES;
        }
    }];
    return equal;
}

@end
