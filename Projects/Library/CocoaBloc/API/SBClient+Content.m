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

    return [self rac_POST:[NSString stringWithFormat:@"account/%@/%@/%@/like", content.accountID, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]];
}

- (RACSignal *)unlikeContent:(SBContent *)content {
    NSParameterAssert(content);
    
    return [self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/%@/like", content.accountID, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]];
}

- (RACSignal *)getUsersWhoLikeContent:(SBContent *)content parameters:(NSDictionary *)parameters {
    NSParameterAssert(content);
    NSAssert([content isKindOfClass:[SBContent class]], @"Invalid content object. (Not an SBContent subclass)");
    
    NSString *urlContentType = [[content class] URLPathContentType];
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/%@/likers", content.accountID, urlContentType, content.identifier] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get users who like content: %@", content];
}

- (RACSignal *)deleteContent:(SBContent *)content {
    NSParameterAssert(content);
    
    return [[self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/%@", content.accountID, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"data"];
}

- (RACSignal *)getContentWithIdentifier:(NSNumber *)identifier type:(NSString *)type forAccountWithIdentifier:(NSNumber *)accountIdentifier {
    NSParameterAssert(identifier);
    NSParameterAssert(accountIdentifier);
    NSParameterAssert(type);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/%@", identifier, type, accountIdentifier] parameters:nil]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get %@ (%@) for account %@", type, identifier, accountIdentifier];
}

- (RACSignal *)flagContent:(SBContent *)content reason:(NSString *)reason {
    return [self flagContentWithIdentifier:content.identifier contentType:[[content class] URLPathContentType] forAccountWithIdentifier:content.accountID reason:reason];
}

- (RACSignal *)flagContentWithIdentifier:(NSNumber *)contentIdentifier contentType:(NSString *)contentType forAccountWithIdentifier:(NSNumber *)accountIdentifier reason:(NSString *)reason {
    NSParameterAssert(contentIdentifier);
    NSParameterAssert(contentType);
    NSParameterAssert(accountIdentifier);
    
    if (!reason) {
        reason = SBAPIMethodParameterFlagContentValueOffensive;
    }
    
    NSDictionary *params = @{SBAPIMethodParameterFlagContent: reason};
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/%@/%@/flag", accountIdentifier, contentType, contentIdentifier] parameters:[self requestParametersWithParameters:params]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Flagging %@ %@ for account %@ because %@", contentType, contentIdentifier, accountIdentifier, reason];
}

@end
