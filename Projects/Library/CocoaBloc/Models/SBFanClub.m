//
//  SBFanClub.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBFanClub.h"
#import <Mantle/Mantle.h>
#import "MTLValueTransformer+Convenience.h"
#import "SBTier.h"
#import "SBClient+Account.h"
#import <RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SBFanClub ()
@property (nonatomic, readonly) RACCommand *fetchAccountCommand;
@end

@implementation SBFanClub

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"accountID"           : @"account",
             @"title" 				: @"title",
             @"descriptiveText" 	: @"description",
             @"userTier" 			: @"user_tier",
             @"canPostStatuses" 	: @"allowed_content_sections.statuses",
             @"canPostPhotos" 		: @"allowed_content_sections.photos",
             @"canPostBlogs" 		: @"allowed_content_sections.blog",
             @"canPostVideos" 		: @"allowed_content_sections.videos",
             @"canPostAudio" 		: @"allowed_content_sections.audio",
             @"moderated"           : @"moderation_queue",
             @"tierOne"             : @"tier_info.1",
             @"tierTwo"             : @"tier_info.2",
             @"tierThree"           : @"tier_info.3",
             @"account"             : NSNull.null,
             };
}

+ (NSValueTransformer*) tierOneJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBTier class]];
}
+ (NSValueTransformer*) tierTwoJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBTier class]];
}
+ (NSValueTransformer*) tierThreeJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBTier class]];
}

- (RACSignal *)fetchAccount {
    return [self.fetchAccountCommand execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
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

@end
