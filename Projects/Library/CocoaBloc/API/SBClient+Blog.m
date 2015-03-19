//
//  SBClient+Blog.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Blog.h"
#import <RACAFNetworking.h>
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
    
    NSMutableDictionary *parameters = parameters != nil ? parameters.mutableCopy : [NSMutableDictionary new];
    parameters[@"title"] = title;
    parameters[@"body"] = body;
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/blog", accountID.stringValue] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Post blog (title: %@, accountID: %@)", title, accountID.stringValue];
}

@end
