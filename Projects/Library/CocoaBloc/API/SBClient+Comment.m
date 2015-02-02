//
//  SBClient+Comment.m
//  CocoaBloc
//
//  Created by John Heaton on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Comment.h"
#import "SBClient+Private.h"
#import "SBComment.h"
#import "SBContent.h"
#import "RACSignal+JSONDeserialization.h"
#import <RACAFNetworking.h>

@implementation SBClient (Comment)

- (RACSignal *)getCommentsForContent:(SBContent *)content parameters:(NSDictionary *)parameters {
    NSParameterAssert(content);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/%@/comments", content.accountID, [[content class] URLPathContentType], content.identifier]
                parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get comments for content: %@", content];
}

- (RACSignal *)getRepliesToComment:(SBComment *)comment parameters:(NSDictionary *)parameters {
    NSParameterAssert(comment);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/comment/%@/replies", comment.accountID, comment.content.identifier, comment.identifier] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get replies to comment: %@", comment];
}

- (RACSignal *)deleteComment:(SBComment *)comment {
    NSParameterAssert(comment);
    
    return [[[self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/comment/%@", comment.accountID, comment.content.identifier, comment.identifier] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Delete comment: %@", comment];
}

- (RACSignal *)postCommentWithText:(NSString *)text onContent:(SBContent *)content parameters:(NSDictionary *)parameters {
    NSParameterAssert(text);
    NSParameterAssert(content);
    
    NSMutableDictionary *p = parameters.mutableCopy ?: [NSMutableDictionary new];
    p[@"text"] = text;
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/%@/%@/comment", content.accountID, [[content class] URLPathContentType], content.identifier] parameters:[self requestParametersWithParameters:p]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Post comment (text: %@) to content: %@", text, content];
}

- (RACSignal *)postCommentWithText:(NSString *)text inReplyToComment:(SBComment *)comment parameters:(NSDictionary *)parameters {
    NSMutableDictionary *p = parameters.mutableCopy ?: [NSMutableDictionary new];
    p[@"reply_to_id"] = comment.identifier;
    
    return [self postCommentWithText:text onContent:comment.content parameters:p];
}

- (RACSignal *)getCommentWithID:(NSNumber *)commentID forContent:(SBContent *)content {
    NSParameterAssert(commentID);
    NSParameterAssert(content);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/comment/%@", content.accountID, [[content class] URLPathContentType], commentID] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get comment (id: %@) for content: %@", commentID, content];
}

- (RACSignal *)flagComment:(SBComment *)comment reason:(NSString *)reason {
    return [self flagCommentWithIdentifier:comment.identifier contentType:[[comment.content class] URLPathContentType] forAccountWithIdentifier:comment.accountID reason:reason];
}

- (RACSignal *)flagCommentWithIdentifier:(NSNumber *)commentIdentifier
                             contentType:(NSString *)contentType
                forAccountWithIdentifier:(NSNumber *)accountIdentifier
                                  reason:(NSString *)reason {
    NSParameterAssert(commentIdentifier);
    NSParameterAssert(contentType);
    NSParameterAssert(accountIdentifier);
    
    if (!reason) {
        reason = SBAPIMethodParameterFlagContentValueOffensive;
    }
    
    NSDictionary *params = @{SBAPIMethodParameterFlagContent: reason};
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/%@/comment/%@/flag", accountIdentifier, contentType, commentIdentifier] parameters:[self requestParametersWithParameters:params]]
             cb_deserializeWithClient:self keyPath:@"data"]
            setNameWithFormat:@"Flagging comment %@ %@ for account %@ because %@", commentIdentifier, contentType, accountIdentifier, reason];
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Flagging comment %@ %@ for account %@ because %@", commentIdentifier, contentType, accountIdentifier, reason];
}

@end
