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
#import "RACSignal+JSONDeserialization.h"
#import <RACAFNetworking.h>

@implementation SBClient (Comment)

- (RACSignal *)getCommentsForContent:(SBContent *)content parameters:(NSDictionary *)parameters {
    NSParameterAssert(content);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/%@/comments", content.accountID, [[content class] URLPathContentType], content.identifier]
                parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self modelClass:[SBComment class] keyPath:@"data"]
                setNameWithFormat:@"Get comments for content: %@", content];
}

- (RACSignal *)getRepliesToComment:(SBComment *)comment {
    NSParameterAssert(comment);
    
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/%@/comment/%@/replies", comment.accountID, comment.content.identifier, comment.identifier] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeArrayWithClient:self modelClass:[SBComment class] keyPath:@"data"]
                setNameWithFormat:@"Get replies to comment: %@", comment];
}

- (RACSignal *)deleteComment:(SBComment *)comment {
    NSParameterAssert(comment);
    
    return [[[self rac_DELETE:[NSString stringWithFormat:@"account/%@/%@/comment/%@", comment.accountID, comment.content.identifier, comment.identifier] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self modelClass:[SBComment class] keyPath:@"data"]
                setNameWithFormat:@"Delete comment: %@", comment];

}

@end
