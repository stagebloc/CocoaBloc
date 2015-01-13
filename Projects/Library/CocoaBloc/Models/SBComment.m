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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SBClient.h"
#import "SBClient+User.h"
#import "SBClient+Account.h"
#import <RACEXTScope.h>

@interface SBComment ()
// Fetches the user for the model's user ID. MUST be executed with an SBClient as the parameter
@property (nonatomic, readonly) RACCommand *fetchUser;
@property (nonatomic, readonly) RACCommand *fetchAccount;

@end

@implementation SBComment

- (RACSignal *)getUser {
    return [self.fetchUser execute:nil];
}

- (RACSignal *)getAccount {
    return [self.fetchAccount execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchUser = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);

            return self.user != nil
            ? [RACSignal return:self.user]
            : [[[SBClient new] getUserWithID:self.userID]
                doNext:^(SBUser *user) {
                    self.user = user;
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

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"accountID"          : @"account",
              @"account"            : @"account",
              @"content"            : @"content",
              @"creationDate"       : @"text",
              @"inModeration"       : @"in_moderation",
              @"replyCount"         : @"reply_count",
              @"parentCommentID"    : @"reply_to",
              @"shortURL"           : @"short_url",
              @"text"               : @"text",
              @"userID"             : @"user",
              @"user"               : @"user"
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
