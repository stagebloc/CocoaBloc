//
//  SBObject.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
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
#import "SBAccountPhoto.h"
#import "SBUserPhoto.h"
#import "SBUser.h"
#import "SBAccount.h"
#import "SBEvent.h"
#import "SBTier.h"
#import "SBStoreDashboard.h"
#import "SBFanClubDashboard.h"

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
						   @"user_photo"                        : [SBUserPhoto class],
						   @"account"                           : [SBAccount class],
						   @"fan_club"                          : [SBFanClub class],
						   @"fan_club_tier"                     : [SBTier class],
						   @"fan_club_dashboard"                : [SBFanClubDashboard class],
						   @"photo"                             : [SBAccountPhoto class],
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
						   @"event"								: [SBEvent class],
						   };
	});
	
	return _kindModelMap[JSONDictionary[@"kind"]];
}

@end
