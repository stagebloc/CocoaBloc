//
//  MTLValueTransformer+Convenience.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <ReactiveCocoa/RACEXTScope.h>
#import <Mantle/Mantle.h>

#import "MTLValueTransformer+Convenience.h"
#import "SBContent.h"

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
        if ([dateString isKindOfClass:[NSNumber class]]) {
            return nil;
        }

        return !dateString ? nil : [dateFormatter dateFromString:dateString];
	} reverseBlock:^id(NSDate *date) {
		return [dateFormatter stringFromDate:date];
	}];
}

+ (instancetype)reversibleModelIDOnlyTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id object) {
        if ([object isKindOfClass:[NSNumber class]]) {
            return object;
        }
        
        return [object objectForKey:@"id"];
    } reverseBlock:^id(id object) {
        return object;
    }];
}

+ (instancetype)reversibleModelJSONOnlyTransformer {
    return [self reversibleModelJSONOnlyTransformerForModelClass:[SBObject class]];
}

+ (instancetype)reversibleModelJSONOnlyTransformerForModelClass:(Class)modelClass {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:object error:nil];
        } else if ([object isKindOfClass:[NSArray class]]) {
            return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:object error:nil];
        }
        
        return nil;
    } reverseBlock:^id(id object) {
        if ([object isKindOfClass:[NSArray class]]) {
            return [MTLJSONAdapter JSONArrayFromModels:object];
        }
        
        return object == nil ? nil : [MTLJSONAdapter JSONDictionaryFromModel:object];
    }];
}

@end
