//
//  SBNotificationSettings.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/29/15.
//  Copyright (c) 2015 Fullscreen Direct. All rights reserved.
//

#import "SBNotificationSettings.h"

@implementation SBNotificationSettings

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"email"   : @"email",
			 @"push"    : @"push",
			 @"web"     : @"web"};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
	return [SBNotificationSettings class];
}

@end
