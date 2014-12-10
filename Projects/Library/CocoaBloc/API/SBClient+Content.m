//
//  SBClient+Content.m
//  CocoaBloc
//
//  Created by John Heaton on 12/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Content.h"
#import "SBClient+Private.h"
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

@end
