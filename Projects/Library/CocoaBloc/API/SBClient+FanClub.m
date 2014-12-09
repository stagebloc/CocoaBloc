//
//  SBClient+FanClub.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+FanClub.h"
#import "SBClient.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>
#import "SBClient+Private.h"
#import "RACSignal+JSONDeserialization.h"

@implementation SBClient (FanClub)

- (RACSignal *)createFanClubForAccount:(SBAccount *)account
                                 title:(NSString *)title
                           description:(NSString *)description
                              tierInfo:(NSDictionary *)tierInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    if (title.length > 0) {
        params[@"title"] = title;
    }
    if (description.length > 0) {
        params[@"description"] = description;
    }
    if (tierInfo) {
        params[@"tier_info"] = tierInfo;
    }
    params[@"expand"] = @"account,photo";
    
    return [[self rac_POST:[NSString stringWithFormat:@"account/%d/fanclub", account.identifier.intValue] parameters:[self requestParametersWithParameters:params]]
            	setNameWithFormat:@"Create %lu-tier fan club \"%@\" (account: %@)", (unsigned long)tierInfo.allKeys.count, title, account];
}

- (RACSignal *)getContentFromFanClubForAccount:(SBAccount *)account
                                    parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:(4 + parameters.count)];
    
    params[@"expand"] = @"user,photo";
    [params addEntriesFromDictionary:parameters];
    params[@"filter"] = @"blog,photos,statuses";
    
    return [[self rac_GET:[NSString stringWithFormat:@"account/%@/fanclub/content", account.identifier] parameters:[self requestParametersWithParameters:params]]
            	setNameWithFormat:@"Get content from fan club (account: %@)", account];
}

- (RACSignal *)getRecentFanClubContentWithParameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2 + 2 * parameters.count];
    
    [params addEntriesFromDictionary:parameters];
    params[@"expand"] = @"user,account,photo";
    
    return [[[self rac_GET:@"account/fanclubs/following/content" parameters:[self requestParametersWithParameters:params]]
                cb_deserializeContentArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get recent fan club content"];
}

@end
