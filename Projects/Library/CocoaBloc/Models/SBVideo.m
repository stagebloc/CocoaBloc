//
//  SBVideoUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBVideo.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/Mantle.h>

@implementation SBVideo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"descriptiveText"    : @"description",
              @"videoURL" 			: @"video_url"}];
}

+ (MTLValueTransformer *)videoURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
