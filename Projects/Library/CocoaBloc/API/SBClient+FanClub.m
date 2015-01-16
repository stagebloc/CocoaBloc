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
#import "SBFanClub.h"

@implementation SBClient (FanClub)

- (RACSignal *)createFanClubForAccountIdentifier:(NSNumber *)accountIdentifier
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
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%d/fanclub", accountIdentifier.intValue] parameters:[self requestParametersWithParameters:params]]
                cb_deserializeWithClient:self keyPath:@"data"]
            	setNameWithFormat:@"Create %lu-tier fan club \"%@\" (account: %@)", (unsigned long)tierInfo.allKeys.count, title, accountIdentifier];
}

- (RACSignal *)getContentFromFanClubForAccount:(SBAccount *)account
                                    parameters:(NSDictionary *)parameters {
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/fanclub/content", account.identifier] parameters:[self requestParametersWithParameters:parameters]]
            	cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get content from fan club (account: %@)", account];
}

- (RACSignal *)getContentFromFollowedFanClubsWithParameters:(NSDictionary *)parameters {
    return [[[self rac_GET:@"account/fanclubs/following/content" parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get recent fan club content"];
}

- (RACSignal*)getFollowedFanClubsWithParameters:(NSDictionary*)parameters {
    return [[[self rac_GET:@"account/fanclubs/following" parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get followed fan clubs"];
}

- (RACSignal*)getRecentFanClubsWithParameters:(NSDictionary*)parameters {
    return [[[self rac_GET:@"account/fanclubs/recent" parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get followed fan clubs"];
}

- (RACSignal*)getFeaturedFanClubsWithParameters:(NSDictionary*)parameters {
    return [[[self rac_GET:@"account/fanclubs/featured" parameters:[self requestParametersWithParameters:parameters]]
             cb_deserializeArrayWithClient:self keyPath:@"data"]
            setNameWithFormat:@"Get followed fan clubs"];
}


- (RACSignal*)getFanClubForAccountIdentifier:(NSNumber*)accountIdentifier parameters:(NSDictionary *)parameters {
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%d/fanclub", accountIdentifier.intValue] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get fan club details"];
}

@end
