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

- (RACSignal *)likeContent:(SBContent *)content onBehalfOfAccount:(SBAccount *)account {
    NSParameterAssert(content);
    NSParameterAssert(account);

    return [self rac_POST:[NSString stringWithFormat:@"account/%@/%@/%@/like", account.identifier, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]];
}

- (RACSignal *)unlikeContent:(SBContent *)content onBehalfOfAccount:(SBAccount *)account {
    NSParameterAssert(content);
    NSParameterAssert(account);
    
    return [self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/%@/like", account.identifier, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]];
}

- (RACSignal *)getUsersWhoLikeContent:(SBContent *)content parameters:(NSDictionary *)parameters {
    NSParameterAssert(content);
    NSAssert([content isKindOfClass:[SBContent class]], @"Invalid content object. (Not an SBContent subclass)");
    
    NSString *url = nil;
    if ([content isKindOfClass:[SBPhoto class]]) {
        url = [NSString stringWithFormat:@"account/%@/photo/%@/likers", content.account.identifier, content.identifier];
    } else if ([content isKindOfClass:[SBStatus class]]) {
        url = [NSString stringWithFormat:@"account/%@/status/%@/likers", content.account.identifier, content.identifier];
    } else if ([content isKindOfClass:[SBBlog class]]) {
        url = [NSString stringWithFormat:@"account/%@/blog/%@/likers", content.account.identifier, content.identifier];
    } else {
        [NSException raise:@"SBCocoaBlocUnsupportedContentParameterException" format:@"%@ objects are not yet supported for this endpoint", NSStringFromClass(content.class)];
    }
    
    return [[[self rac_GET:url parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self modelClass:[SBUser class] keyPath:@"data"]
                setNameWithFormat:@"Get users who like content: %@", content];
}

@end
