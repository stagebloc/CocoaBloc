//
//  SBNotification.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBNotification.h"
#import <MTLValueTransformer.h>
#import <NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"
#import "NSDateFormatter+CocoaBloc.h"
#import "SBAccount.h"
#import <RACEXTScope.h>
#import "SBClient+Account.h"
#import <RACCommand.h>

@interface SBNotification ()
@property (nonatomic, readonly) RACCommand *fetchAccountCommand;
@end

@implementation SBNotification

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
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

- (RACSignal *)fetchAccount {
    return [self.fetchAccountCommand execute:nil];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"creationDate"               : @"created",
              @"HTMLText"                   : @"html_message",
              @"text"                       : @"message",
              @"route"                      : @"route",
              @"accountID"                  : @"account",
              @"account"                    : @"account",
              @"fetchAccountCommand"        : [NSNull null]
              }];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)accountJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)accountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

@end
