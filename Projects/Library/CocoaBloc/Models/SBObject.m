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

@implementation SBObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"identifier" : @"id"};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"reply_to"] != nil) {
        return [SBComment class];
    }
    if (JSONDictionary[@"street_address"] != nil) {
        return [SBAddress class];
    }
    if (JSONDictionary[@"stripe_charge_id"] != nil) {
        return [SBOrder class];
    }
    if (JSONDictionary[@"route"] != nil) {
        return [SBNotification class];
    }
    if (JSONDictionary[@"userTier"] != nil) {
        return [SBFanClub class];
    }
    if (JSONDictionary[@"video_url"] != nil) {
        return [SBVideo class];
    }
    if (JSONDictionary[@"edit_url"] != nil) {
        return [SBAudio class];
    }
    if (JSONDictionary[@"sold_out"] != nil) {
        return [SBStoreItem class];
    }
    if (JSONDictionary[@"upc"] != nil) {
        return [SBStoreItemOption class];
    }
    if (JSONDictionary[@"currency"] != nil) {
        return [SBStoreItemPriceConfiguration class];
    }
    if (JSONDictionary[@"body"] != nil) {
        return [SBBlog class];
    }
    if (JSONDictionary[@"text"] != nil) {
        return [SBStatus class];
    }
    if (JSONDictionary[@"images"] != nil) {
        return [SBPhoto class];
    }
    if (JSONDictionary[@"verified"] != nil) {
        return [SBAccount class];
    }
    if (JSONDictionary[@"username"] != nil) {
        return [SBUser class];
    }
    
    return nil;
}

@end
