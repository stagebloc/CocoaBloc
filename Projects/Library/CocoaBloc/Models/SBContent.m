//
//  SBContent.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "MTLValueTransformer+Convenience.h"
#import "NSDateFormatter+CocoaBloc.h"
#import <Mantle/Mantle.h>

#import "SBAccount.h"
#import "SBPhoto.h"
#import "SBBlog.h"
#import "SBStatus.h"

@implementation SBContent

+ (Class)modelClassForJSONContentType:(NSString *)contentType {
    static NSDictionary *contentTypeToModelClassMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentTypeToModelClassMap = @{@"photos"    : [SBPhoto class],
                                       @"blog"      : [SBBlog class],
                                       @"statuses"  : [SBStatus class]};
    });
    
    return contentTypeToModelClassMap[contentType];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"commentCount" 	: @"comment_count",
			  @"creationDate" 	: @"created",
			  @"excerpt"		: @"excerpt",
			  @"inModeration"	: @"in_moderation",
			  @"likeCount"		: @"like_count",
			  @"publishDate"	: @"published",
			  @"shortURL"		: @"short_url",
			  @"title"			: @"title",
			  @"userHasLiked"	: @"user_has_liked",
              @"account"        : @"account"}];
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (NSValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (NSValueTransformer *)publishDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id accountValue) {
        if ([accountValue isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:[SBAccount class]
                             fromJSONDictionary:accountValue
                                          error:nil];
        }
        return accountValue;
    } reverseBlock:^id(id accountValue) {
        if ([accountValue isKindOfClass:[SBAccount class]]) {
            return [MTLJSONAdapter JSONDictionaryFromModel:accountValue];
        }
        return accountValue;
    }];
}

@end
