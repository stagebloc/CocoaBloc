//
//  SBClient+Account.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Account.h"
#import <RACAFNetworking.h>
#import "SBClient+Private.h"
#import "SBAccount.h"
#import "RACSignal+JSONDeserialization.h"
#import "AFHTTPRequestOperationManager+File.h"
#import "NSData+Mime.h"

@implementation SBClient (Account)

- (RACSignal *)createAccountWithName:(NSString*)name url:(NSString*)url type:(NSString*)type {
    return [self createAccountWithName:name url:url type:type photoData:nil photoProgressSignal:nil];
}

- (RACSignal *)createAccountWithName:(NSString*)name url:(NSString*)url type:(NSString*)type photoData:(NSData*)photoData photoProgressSignal:(RACSignal**)photoProgressSignal {
    NSParameterAssert(name);
    NSParameterAssert(url);
    NSParameterAssert(type);
    
    NSAssert(name.length != 0, @"Name must have character length > 0");
    NSAssert(url.length != 0, @"Name must have character length > 0");
    NSAssert(type.length != 0, @"Name must have character length > 0");

    NSDictionary *params = @{@"name"            : name,
                             @"stagebloc_url"   : url,
                             @"type"            : type
                             };

    if (!photoData) {
        return [[[self rac_POST:@"account" parameters:[self requestParametersWithParameters:params]]
                    cb_deserializeWithClient:self keyPath:@"data"]
                    setNameWithFormat:@"Create account %@", name];
    }
    
    NSString *mime = [photoData photoMime];
    if (!mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }
    
    NSError *err;
    AFHTTPRequestOperation *op =
    [self fileRequestFromData:photoData
                         name:@"image"
                     fileName:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]
                     mimeType:mime
                          url:[self.baseURL URLByAppendingPathComponent:@"account"].absoluteString
                   parameters:params
                        error:&err
               progressSignal:photoProgressSignal];
    
    if (err) {
        return [RACSignal error:err];
    }
    
    return [[[self enqueueRequestOperation:op]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Create account %@", name];

}

- (RACSignal *)getAccountWithID:(NSNumber *)accountID {
    NSParameterAssert(accountID);

    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@", accountID] parameters:[self requestParametersWithParameters:nil]]
            	cb_deserializeWithClient:self keyPath:@"data"]
            	setNameWithFormat:@"Get account with ID: %@", accountID];
}

- (RACSignal *)updateAccountWithIdentifier:(NSNumber *)accountIdentifier
                                      name:(NSString *)name
                               description:(NSString *)description
                              stageBlocURL:(NSString *)urlString {
    NSParameterAssert(accountIdentifier);
    NSAssert(name != nil || description != nil || urlString != nil, @"To update the account, provide at least one property to update.");
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (name) 			dict[@"name"] = name.copy;
    if (description) 	dict[@"description"] = description.copy;
    if (urlString)		dict[@"stagebloc_url"] = urlString.copy;
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@", accountIdentifier] parameters:[self requestParametersWithParameters:dict]]
            	cb_deserializeWithClient:self keyPath:@"data"]
            	setNameWithFormat:@"Update account (%@)", accountIdentifier];
}

- (RACSignal *)getActivityStreamForAccountWithIdentifier:(NSNumber *)accountIdentifier parameters:(NSDictionary*)parameters {
    NSParameterAssert(accountIdentifier);

    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/content", accountIdentifier] parameters:[self requestParametersWithParameters:parameters]]
                cb_deserializeArrayWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get activity stream for account %@", accountIdentifier];
}

- (RACSignal *)getChildrenAccountsForAccount:(NSNumber *)accountId withType:(NSString *)type {
    NSParameterAssert(accountId);

    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/children/%@", accountId, (nil == type ? @"" : type)] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeArrayWithClient:self keyPath:@"data.child_accounts"]
                setNameWithFormat:@"Get children accounts (accountID: %d])", accountId.intValue];
}

- (RACSignal*)followAccountWithIdentifier:(NSNumber*)identifier {
    NSParameterAssert(identifier);
    
    return [[[self rac_POST:[NSString stringWithFormat:@"account/%d/follow", identifier.intValue] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"account"]
                setNameWithFormat:@"Follow account %d", identifier.intValue];
}

- (RACSignal*)unfollowAccountWithIdentifier:(NSNumber*)identifier {
    NSParameterAssert(identifier);
    
    return [[[self rac_DELETE:[NSString stringWithFormat:@"account/%d/follow", identifier.intValue] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"account"]
                setNameWithFormat:@"Unfollow account %d", identifier.intValue];
}

@end
