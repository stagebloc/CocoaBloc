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

#import "SBPhoto.h"
#import "SBBlog.h"
#import "SBStatus.h"
#import "SBVideo.h"
#import "SBAudio.h"

#import "SBUser.h"
#import "SBAccount.h"

@implementation SBContent

+ (Class)modelClassForJSONContentType:(NSString *)contentType {
    static NSDictionary *contentTypeToModelClassMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentTypeToModelClassMap = @{@"photos"    : [SBPhoto class],
                                       @"blog"      : [SBBlog class],
                                       @"statuses"  : [SBStatus class],
                                       @"videos"    : [SBVideo class],
                                       @"audio"     : [SBAudio class]};
    });
    
    return contentTypeToModelClassMap[contentType];
}

+ (NSString *)URLPathContentType {
    static NSDictionary *classToContentURLContentTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classToContentURLContentTypes = @{NSStringFromClass([SBPhoto class])   : @"photo",
                                          NSStringFromClass([SBBlog class])    : @"blog",
                                          NSStringFromClass([SBStatus class])  : @"status",
                                          NSStringFromClass([SBVideo class])   : @"video",
                                          NSStringFromClass([SBAudio class])   : @"audio"};
    });
    
    return classToContentURLContentTypes[NSStringFromClass(self)];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{
              @"title"                  : @"title",
              @"excerpt"                : @"excerpt",
              @"modificationDate"       : @"modified",
              @"creationDate"           : @"created",
              @"publishDate"            : @"published",
              @"inModeration"           : @"in_moderation",
              @"isFanContent"           : @"is_fan_content",
              @"userHasLiked"           : @"user_has_liked",
              @"likeCount"              : @"like_count",
              @"isSticky"               : @"sticky",
              @"isExclusive"            : @"exclusive",
              @"commentCount"           : @"comment_count",
			  @"shortURL"               : @"short_url",
              @"accountOrAccountID"     : @"account",
              @"authorOrAuthorUserID"   : @"user"
            }];
}

+ (NSValueTransformer *)modificationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (NSValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (NSValueTransformer *)publishDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)accountOrAccountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBAccount class]];
}

+ (MTLValueTransformer *)authorOrAuthorUserIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBUser class]];
}

- (NSNumber *)accountID {
    return [self.accountOrAccountID isKindOfClass:[SBAccount class]] ? [self.accountOrAccountID identifier] : self.accountOrAccountID;
}

- (NSNumber *)authorUserID {
    return [self.authorOrAuthorUserID isKindOfClass:[SBUser class]] ? [self.authorOrAuthorUserID identifier] : self.authorOrAuthorUserID;
}

@end
