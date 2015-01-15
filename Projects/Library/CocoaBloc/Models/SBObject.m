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
#import <MTLModel+NSCoding.h>

@implementation SBObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"identifier" : @"id"};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    static NSDictionary *_kindModelMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _kindModelMap = @{ @"user"          : [SBUser class],
                           @"account"       : [SBAccount class],
                           @"order"         : [SBOrder class],
                           @"store_item"    : [SBStoreItem class],
                           @"fan_club"      : [SBFanClub class],
                           @"photo"         : [SBPhoto class],
                           @"audio"         : [SBAudio class],
                           @"blog"          : [SBBlog class],
                           @"status"        : [SBStatus class],
                           @"video"         : [SBVideo class],
                           @"comment"       : [SBComment class],
                           @"notification"  : [SBNotification class],
                           @"address"       : [SBAddress class],
                           @"store_item_option" : [SBStoreItemOption class],
                           @"store_item_shipping_price_handler" : [SBStoreItemPriceConfiguration class] };
    });
    
    return _kindModelMap[JSONDictionary[@"kind"]];
}

@end
