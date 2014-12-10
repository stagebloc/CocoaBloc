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
#import "MTLValueTransformer+Convenience.h"
#import "NSDictionary+MTLManipulationAdditions.h"
#import <Mantle/MTLValueTransformer.h>

@implementation SBComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"accountOrAccountID" : @"account",
              @"content"            : @"content",
              @"creationDate"       : @"text",
              @"inModeration"       : @"in_moderation",
              @"replyCount"         : @"reply_count",
              @"parentCommentID"    : @"reply_to",
              @"shortURL"           : @"short_url",
              @"text"               : @"text",
              @"userOrUserID"       : @"user"
            }];
}

+ (MTLValueTransformer *)contentJSONTransformer {
    return [MTLValueTransformer reversibleContentModelIDOrJSONTransformer];
}

+ (MTLValueTransformer *)accountOrAccountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBAccount class]];
}

+ (MTLValueTransformer *)userOrUserIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBUser class]];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

- (NSNumber *)accountID {
    return [self.accountOrAccountID isKindOfClass:[SBAccount class]] ? [self.accountOrAccountID identifier] : self.accountOrAccountID;
}

- (NSNumber *)userID {
    return [self.userOrUserID isKindOfClass:[SBUser class]] ? [self.userOrUserID identifier] : self.userOrUserID;
}

@end
