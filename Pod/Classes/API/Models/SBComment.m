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
@property (nonatomic, readonly) RACCommand *fetchUserCommand;
@property (nonatomic, readonly) RACCommand *fetchAccountCommand;

@end

@implementation SBComment

- (RACSignal *)fetchUser {
    return [self fetchUserWithClient:nil];
}
- (RACSignal*)fetchUserWithClient:(SBClient*)client {
    return [self.fetchUserCommand execute:client];
}
- (RACSignal *)fetchAccount {
    return [self fetchAccountWithClient:nil];
}
- (RACSignal*)fetchAccountWithClient:(SBClient*)client {
    return [self.fetchAccountCommand execute:client];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];

            return self.user != nil
            ? [RACSignal return:self.user]
            : [[client getUserWithID:self.userID]
                doNext:^(SBUser *user) {
                    self.user = user;
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
