//
//  MTLValueTransformer+Convenience.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "MTLValueTransformer+Convenience.h"

@implementation MTLValueTransformer (Convenience)

+ (instancetype)reversibleStringToURLTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *urlString) {
		return [NSURL URLWithString:urlString];
	} reverseBlock:^id(NSURL *url) {
		return url.absoluteString;
	}];
}

+ (instancetype)reversibleStringToDateTransformerWithFormatter:(NSDateFormatter *)dateFormatter {
	NSParameterAssert(dateFormatter);
	
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *dateString) {
		return [dateFormatter dateFromString:dateString];
	} reverseBlock:^id(NSDate *date) {
		return [dateFormatter stringFromDate:date];
	}];
}

@end
