//
//  SBVideoUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBVideo.h"
#import "SBUser.h"
#import "NSDateFormatter+CocoaBloc.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/Mantle.h>
#import <EXTKeyPathCoding.h>

@implementation SBVideo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"title"              : @"title",
              @"descriptiveText"    : @"description",
              @"shortURL" 		 	: @"short_url",
              @"videoURL" 			: @"video_url",
              @"creationDate" 		: @"created",
              @"modificationDate"	: @"modified",
              @"inModeration" 	 	: @"in_moderation",
              @"inFanContent"       : @"in_fan_content",
              @"commentCount"       : @"comment_count",
              @"likeCount" 		 	: @"like_count",
//              @"exclusive" 		 	: @"exclusive",
              @"userOrID" 			: @"user",
              @"userHasLiked" 	 	: @"user_has_liked"}];
}

+ (MTLValueTransformer *)userOrIDJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id userValue) {
        if ([userValue isKindOfClass:[NSDictionary class]]) {
            return [MTLJSONAdapter modelOfClass:[SBUser class]
                             fromJSONDictionary:userValue
                                          error:nil];
        }
        return userValue;
    } reverseBlock:^id(id userValue) {
        if ([userValue isKindOfClass:[SBUser class]]) {
            return [MTLJSONAdapter JSONDictionaryFromModel:userValue];
        }
        return userValue;
    }];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)modificationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)videoURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
