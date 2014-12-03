//
//  SBVideoUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBVideoUpload.h"
#import "NSDateFormatter+CocoaBloc.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/Mantle.h>
#import <EXTKeyPathCoding.h>

@implementation SBVideoUpload

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
              @"userID" 			: @"user",
              @"userHasLiked" 	 	: @"user_has_liked"}];
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
