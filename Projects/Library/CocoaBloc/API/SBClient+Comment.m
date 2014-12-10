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

@end
