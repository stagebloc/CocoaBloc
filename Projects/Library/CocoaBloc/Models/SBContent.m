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
#import <RACCommand.h>
#import "SBClient+Account.h"
#import "SBClient+User.h"
#import <RACEXTScope.h>

@implementation SBContent

- (RACSignal *)fetchAccount {
    return [self.fetchAccountCommand execute:nil];
}

- (RACSignal *)fetchAuthorUser {
    return [self.fetchAuthorUserCommand execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAuthorUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];
            
            return self.authorUser != nil
            ? [RACSignal return:self.authorUser]
            : [[client getAccountWithID:self.authorUserID]
               doNext:^(SBUser *user) {
                   self.authorUser = user;
               }];
        }];

        
        _fetchAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];

            return self.account != nil
            ? [RACSignal return:self.account]
            : [[client getAccountWithID:self.accountID]
               doNext:^(SBAccount *account) {
                   self.account = account;
               }];
        }];
    }
    return self;
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
              @"accountID"              : @"account",
              @"account"                : @"account",
              @"authorUser"             : @"user",
              @"authorUserID"           : @"user",
              @"fetchAuthorUserCommand" : [NSNull null],
              @"fetchAccountCommand"    : [NSNull null]}
            ];
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

+ (MTLValueTransformer *)accountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
