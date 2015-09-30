//
//  MTLValueTransformer+CocoaBloc.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "MTLValueTransformer+CocoaBloc.h"
#import "SBContent.h"

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
            return [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:object error:nil];
        } else if ([object isKindOfClass:[NSArray class]]) {
            return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:object error:nil];
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

@end
