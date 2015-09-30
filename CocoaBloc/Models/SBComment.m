//
//  SBComment.m
//  CocoaBloc
//
//  Created by John Heaton on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBComment.h"
#import "SBUser.h"
#import "NSDateFormatter+CocoaBloc.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import <Mantle/MTLValueTransformer.h>

@implementation SBComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"accountID"          : @"account",
              @"account"            : @"account",
              @"content"            : @"content",
              @"creationDate"       : @"created",
              @"inModeration"       : @"in_moderation",
              @"replyCount"         : @"reply_count",
              @"parentCommentID"    : @"reply_to",
              @"shortURL"           : @"short_url",
              @"text"               : @"text",
              @"userID"             : @"user",
              @"user"               : @"user",
              @"fetchUserCommand"   : [NSNull null],
              @"fetchAccountCommand": [NSNull null]
            }];
}

+ (MTLValueTransformer *)contentJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)accountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)userIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)userJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

@end
