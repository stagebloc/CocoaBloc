//
//  MTLValueTransformer+Convenience.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "MTLValueTransformer+Convenience.h"
#import <Mantle/Mantle.h>
#import "SBContent.h"
#import <RACEXTScope.h>

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

+ (instancetype)reversibleModelOnlyTransformerWithClass:(Class)modelClass {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id object) {
        if (![object isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        return [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:object error:nil];
    } reverseBlock:^id(id object) {
        return object == nil ? nil : [MTLJSONAdapter JSONDictionaryFromModel:object];
    }];
}

+ (instancetype)reversibleModelIDOrJSONTransformerForClass:(Class)modelClass {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id value) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:modelClass
                             fromJSONDictionary:value
                                          error:nil];
        }
        return value;
    } reverseBlock:^id(id value) {
        if ([value isKindOfClass:modelClass]) {
            return [MTLJSONAdapter JSONDictionaryFromModel:value];
        }
        return value;
    }];
}

+ (instancetype)reversibleContentModelIDOrJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id value) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:[SBContent modelClassForJSONContentType:[value objectForKey:@"content_type"]]
                             fromJSONDictionary:value
                                          error:nil];
        }
        return value;
    } reverseBlock:^id(id value) {
        if ([value isKindOfClass:[SBContent modelClassForJSONContentType:[value objectForKey:@"content_type"]]]) {
            return [MTLJSONAdapter JSONDictionaryFromModel:value];
        }
        return value;
    }];
}

@end
