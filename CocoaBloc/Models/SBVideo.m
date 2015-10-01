//
//  SBVideoUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBVideo.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import <Mantle/Mantle.h>

@implementation SBVideo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"descriptiveText"    : @"description",
              @"videoURL" 			: @"video_url",
              @"videoCDNURL" 		: @"video_cdn_url",
              @"photo"              : @"photo",
              @"photoID"            : @"photo",
              @"descriptiveText"    : @"description"
              }];
}

+ (MTLValueTransformer *)videoURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)videoCDNURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)photoJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)photoIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

@end
