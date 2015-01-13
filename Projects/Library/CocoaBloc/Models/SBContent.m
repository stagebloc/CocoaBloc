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

@interface SBContent ()
@property (nonatomic, readonly) RACCommand *fetchAccount;
@property (nonatomic, readonly) RACCommand *fetchAuthorUser;
@end

@implementation SBContent

- (RACSignal *)getAccount {
    return [self.fetchAccount execute:nil];
}

- (RACSignal *)getAuthorUser {
    return [self.fetchAuthorUser execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAuthorUser = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.authorUser != nil
            ? [RACSignal return:self.authorUser]
            : [[[SBClient new] getAccountWithID:self.authorUserID]
               doNext:^(SBUser *user) {
                   self.authorUser = user;
               }];
        }];

        
        _fetchAccount = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.account != nil
            ? [RACSignal return:self.account]
            : [[[SBClient new] getAccountWithID:self.accountID]
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
			@{@"title"                  : @"title",
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
              @"authorUserID"           : @"user"}];
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
