//
//  SBClient+Content.m
//  CocoaBloc
//
//  Created by John Heaton on 12/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Content.h"
#import "SBClient+Private.h"
#import "SBBlog.h"
#import "SBStatus.h"
#import "RACSignal+JSONDeserialization.h"
#import <RACAFNetworking.h>


@implementation SBClient (Content)

- (RACSignal *)likeContent:(SBContent *)content {
    NSParameterAssert(content);
    
    return [[[[[RACSignal return:content]
                doNext:^(SBContent *c) {
                    if (!c.userHasLiked.boolValue) {
                        c.userHasLiked = @(YES);
                        c.likeCount = @(c.likeCount.integerValue + 1);
                    }
                }]
                flattenMap:^RACStream *(SBContent *c) {
                    return [self rac_POST:[NSString stringWithFormat:@"account/%@/%@/%@/like", c.accountID, [[c class] URLPathContentType], c.identifier] parameters:[self requestParametersWithParameters:nil]];
                }]
                cb_deserializeWithClient:self keyPath:@"data"]
                doError:^(NSError *error) {
                    if (content.userHasLiked.boolValue) {
                        content.userHasLiked = @(NO);
                        content.likeCount = @(content.likeCount.integerValue - 1);
                    }
                }];
}

- (RACSignal *)unlikeContent:(SBContent *)content {
    NSParameterAssert(content);
    
    return [[[[[RACSignal return:content]
                doNext:^(SBContent *c) {
                    if (c.userHasLiked.boolValue) {
                        c.userHasLiked = @(NO);
                        c.likeCount = @(c.likeCount.integerValue - 1);
                    }
                }]
                flattenMap:^RACStream *(SBContent *c) {
                    return [self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/%@/like", content.accountID, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]];
                }]
                cb_deserializeWithClient:self keyPath:@"data"]
                doError:^(NSError *error) {
                    if (!content.userHasLiked.boolValue) {
                        content.userHasLiked = @(YES);
                        content.likeCount = @(content.likeCount.integerValue + 1);
                    }
                }];
}

- (RACSignal *)getUsersWhoLikeContent:(SBContent *)content parameters:(NSDictionary *)parameters {
    NSParameterAssert(content);
    NSAssert([content isKindOfClass:[SBContent class]], @"Invalid content object. (Not an SBContent subclass)");
    
    NSString *urlContentType = [[content class] URLPathContentType];
    
    return [[[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/%@/likers", content.accountID, urlContentType, content.identifier] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                doNext:^(NSArray *users) {
                    content.likeCount = @(users.count);
                    
                    SBUser *authdUser = [users.rac_sequence objectPassingTest:^BOOL(SBUser *candidate) {
                        return [candidate.identifier isEqualToNumber:self.authenticatedUser.identifier];
                    }];
                    
                    content.userHasLiked = @(authdUser != nil);
                }]
                setNameWithFormat:@"Get users who like content: %@", content];
}

- (RACSignal *)deleteContent:(SBContent *)content {
    NSParameterAssert(content);
    
    return [[self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/%@", content.accountID, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]]
                ignoreValues];
}

- (RACSignal *)getContentWithIdentifier:(NSNumber *)identifier type:(NSString *)type forAccountWithIdentifier:(NSNumber *)accountIdentifier parameters:(NSDictionary *)parameters {
    NSParameterAssert(identifier);
    NSParameterAssert(accountIdentifier);
    NSParameterAssert(type);
    
    if ([type hasSuffix:@"s"]) {
        type = [type substringToIndex:[type length] - ([type hasSuffix:@"es"] ? 2 : 1)];
    }
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/%@", accountIdentifier, type, identifier] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get %@ (%@) for account %@", type, identifier, accountIdentifier];
}

- (RACSignal *)flagContent:(SBContent *)content type:(NSString *)type reason:(NSString *)reason {
    return [self flagContentWithIdentifier:content.identifier contentType:[[content class] URLPathContentType] forAccountWithIdentifier:content.accountID type:type reason:reason];
}

- (RACSignal *)flagContentWithIdentifier:(NSNumber *)contentIdentifier
                             contentType:(NSString *)contentType
                forAccountWithIdentifier:(NSNumber *)accountIdentifier
                                    type:(NSString *)type
                                  reason:(NSString *)reason {
    NSParameterAssert(contentIdentifier);
    NSParameterAssert(contentType);
    NSParameterAssert(accountIdentifier);
    NSParameterAssert(reason);
    
    if (!type) {
        type = SBAPIMethodParameterFlagContentValueOffensive;
    }
    
    NSDictionary *params = @{@"type": type, @"reason": reason};
    
    return [[self rac_POST:[NSString stringWithFormat:@"account/%@/%@/%@/flag", accountIdentifier, contentType, contentIdentifier] parameters:[self requestParametersWithParameters:params]]
                setNameWithFormat:@"Flagging %@ %@ for account %@ because %@", contentType, contentIdentifier, accountIdentifier, reason];
}

@end
