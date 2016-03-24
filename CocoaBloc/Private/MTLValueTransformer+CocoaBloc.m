//
//  MTLValueTransformer+CocoaBloc.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "MTLValueTransformer+CocoaBloc.h"
#import "SBEvent.h"
#import "SBObject.h"
#import "SBUserColor.h"

#if TARGET_OS_IPHONE
@import UIKit.UIColor;
#else
@import AppKit.NSColor;
#endif

@implementation MTLValueTransformer (CocoaBloc)

+ (instancetype)reversibleStringToURLTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *urlString, BOOL *success, NSError **error) {
		*success = YES;
		return [NSURL URLWithString:urlString];
	} reverseBlock:^id(NSURL *url, BOOL *success, NSError **error) {
		*success = YES;
		return url.absoluteString;
	}];
}

+ (instancetype)reversibleStringToDateTransformerWithFormatter:(NSDateFormatter *)dateFormatter {
	NSParameterAssert(dateFormatter);
	
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError **error) {
		*success = YES;
		
		if ([dateString isKindOfClass:[NSNumber class]]) {
			return nil;
		}
		
		return !dateString ? nil : [dateFormatter dateFromString:dateString];
	} reverseBlock:^id(NSDate *date, BOOL *success, NSError **error) {
		*success = YES;
		return [dateFormatter stringFromDate:date];
	}];
}

+ (instancetype)reversibleModelIDOnlyTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(id object, BOOL *success, NSError **error) {
		*success = YES;
		
		if ([object isKindOfClass:[NSNumber class]]) {
			return object;
		}
		
		return [object objectForKey:@"id"];
	} reverseBlock:^id(id object, BOOL *success, NSError **error) {
		*success = YES;
		return object;
	}];
}

+ (instancetype)reversibleModelJSONOnlyTransformer {
	return [self reversibleModelJSONOnlyTransformerForModelClass:[SBObject class]];
}

+ (instancetype)reversibleModelJSONOnlyTransformerForModelClass:(Class)modelClass {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(id object, BOOL *success, NSError **error) {
		*success = YES;
		if ([object isKindOfClass:[NSDictionary class]]) {
			id model = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:object error:error];
			if (*error != nil) {
				*success = NO;
				return nil;
			}
			return model;
		} else if ([object isKindOfClass:[NSArray class]]) {
			NSArray *models = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:object error:error];
			if (*error != nil) {
				*success = NO;
				return nil;
			}
			return models;
		}
		
		return nil;
	} reverseBlock:^id(id object, BOOL *success, NSError **error) {
		*success = YES;
		
		if ([object isKindOfClass:[NSArray class]]) {
			NSArray *models = [MTLJSONAdapter JSONArrayFromModels:object error:error];
			if (*error != nil) {
				*success = NO;
				return nil;
			}
			return models;
		}
		else if ([object isKindOfClass:[NSDictionary class]]) {
			NSDictionary *model = [MTLJSONAdapter JSONDictionaryFromModel:object error:error];
			if (*error != nil) {
				*success = NO;
				return nil;
			}
			return model;
		}
		
		return nil;
	}];
}

+ (instancetype)reversibleStringToTimeZoneTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:value];
		*success = timeZone != nil;
		return timeZone;
	} reverseBlock:^id(NSTimeZone *timeZone, BOOL *success, NSError *__autoreleasing *error) {
		*success = YES;
		return timeZone.name;
	}];
}

+ (instancetype)reversibleEventAttendingStatusTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		// Pulled from AccountEventRsvp::statusString
		if ([value isEqualToString:@"yes"]) {
			return @(SBEventAttendingStatusYes);
		} else if ([value isEqualToString:@"maybe"]) {
			return @(SBEventAttendingStatusMaybe);
		}
		return @(SBEventAttendingStatusNo);
	} reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
		SBEventAttendingStatus status = number.integerValue;
		switch (status) {
			case SBEventAttendingStatusYes:
				return @"yes";
			case SBEventAttendingStatusMaybe:
				return @"maybe";
			case SBEventAttendingStatusNo:
			default:
				return @"no";
		}
	}];
}

+ (instancetype)reversibleUserColorTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^SBUserColor *(NSString *colorString, BOOL *success, NSError **error) {
		NSArray *colorComponents = [colorString componentsSeparatedByString:@","];
		*success = YES;
		
		if (colorComponents.count < 3) {
			// Defaults to blue color if fails to convert (follows server code)
			return [SBUserColor colorWithRed:70.0/255.0
									   green:170.0/255.0
										blue:255.0/255.0
									   alpha:1];
		}
		
		return [SBUserColor colorWithRed:([colorComponents[0] floatValue] / 255)
								   green:([colorComponents[1] floatValue] / 255)
									blue:([colorComponents[2] floatValue] / 255)
								   alpha:1];
	} reverseBlock:^NSString *(SBUserColor *color, BOOL *success, NSError **error) {
		*success = YES;
		
		CGFloat r,g,b,a;
		if ([color getRed:&r green:&g blue:&b alpha:&a]) {
			r *= 255;
			b *= 255;
			g *= 255;
		
			return [NSString stringWithFormat:@"%d,%d,%d", (int)r, (int)g, (int)b];
		} else {
			// Defaults to returning the blue color if we fail to get the components
			return @"70,170,255";
		}
	}];
}

@end
