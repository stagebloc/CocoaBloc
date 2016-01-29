//
//  NSDateFormatter+CocoaBloc.m
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "NSDateFormatter+CocoaBloc.h"

@implementation NSDateFormatter (CocoaBloc)

+ (NSDateFormatter *)CocoaBlocJSONDateFormatter {
	static NSDateFormatter *df;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		df = [NSDateFormatter new];
		df.locale = [NSLocale localeWithLocaleIdentifier:@"EN_US_POSIX"];
		df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
		df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	});
	
	return df;
}

@end
