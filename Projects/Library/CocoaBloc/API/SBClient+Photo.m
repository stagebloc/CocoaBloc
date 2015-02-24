//
//  SBClient+Photo.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Photo.h"
#import <RACAFNetworking.h>
#import "SBClient+Private.h"
#import "RACSignal+JSONDeserialization.h"
#import "AFHTTPRequestOperationManager+File.h"
#import "NSData+Mime.h"

@implementation SBClient (Photo)

- (RACSignal *)getPhotoWithID:(NSNumber *)photoID forAccount:(SBAccount *)account {
    return [[[self rac_GET:[NSString stringWithFormat:@"account/%@/photo/%@", account.identifier, photoID] parameters:[self requestParametersWithParameters:nil]]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Get photo (id: %@, accountID: %@)", photoID, account.identifier];
}

- (RACSignal*)uploadPhotoData:(NSData*)data
                        title:(NSString*)title
                      caption:(NSString*)caption
      toAccountWithIdentifier:(NSNumber*)accountIdentifier
                    exclusive:(BOOL)exclusive
                   fanContent:(BOOL)fanContent
               progressSignal:(RACSignal **)progressSignal
                   parameters:(NSDictionary *)parameters {
    NSParameterAssert(data);
    NSParameterAssert(title);
    NSParameterAssert(accountIdentifier);
    
    NSString* const fileName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%@/photo", accountIdentifier]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    NSString *mime = [data photoMime];
    if (!mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }
    
    //should check file type here
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[title, @(exclusive), @(fanContent)] forKeys:@[@"title", @"exclusive", SBAPIMethodParameterResultFanContent]];
    if (caption) {
        params[@"description"] = caption;
    }
    
    if (parameters) {
        [params addEntriesFromDictionary:parameters];
    }
    
    // create the upload request
    NSError *err;
    AFHTTPRequestOperation *op =
    [self fileRequestFromData:data
                         name:@"photo"
                     fileName:fileName
                     mimeType:mime
                          url:endpointLocation
                   parameters:[self requestParametersWithParameters:params]
                        error:&err
               progressSignal:progressSignal];
    
    if (err) {
        return [RACSignal error:err];
    }
    
    return [[[self enqueueRequestOperation:op]
             cb_deserializeWithClient:self keyPath:@"data"]
            setNameWithFormat:@"Upload photo %@ to account %@", title, accountIdentifier];
}

@end
