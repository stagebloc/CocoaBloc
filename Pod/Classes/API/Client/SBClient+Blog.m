//
//  SBClient+Blog.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AFNetworking-RACExtensions/RACAFNetworking.h>

#import "SBClient+Blog.h"
#import "SBClient+Private.h"
#import "RACSignal+JSONDeserialization.h"

@implementation SBClient (Blog)

- (RACSignal *)postBlogWithTitle:(NSString *)title
                            body:(NSString *)body
         toAccountWithIdentifier:(NSNumber *)accountID
                      parameters:(NSDictionary *)parameters {
    NSParameterAssert(title);
    NSParameterAssert(title.length <= 150); // db limit
    NSParameterAssert(body);
    NSParameterAssert(accountID);
    
    NSMutableDictionary *p = parameters != nil ? parameters.mutableCopy : [NSMutableDictionary new];
    p[@"title"] = title;
    p[@"body"] = body;
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/blog", accountID.stringValue] parameters:[self requestParametersWithParameters:p]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Post blog (title: %@, accountID: %@)", title, accountID.stringValue];
}

@end
