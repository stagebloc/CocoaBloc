//
//  SBClient+Audio.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Audio.h"
#import "SBClient.h"
#import "SBAudio.h"
#import "SBClient+Private.h"
#import "RACSignal+JSONDeserialization.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>
#import "AFHTTPRequestOperationManager+File.h"

@implementation SBClient (Audio)

- (RACSignal *)getAudioTrackWithID:(NSNumber *)audioID forAccountWithIdentifier:(NSNumber *)accountIdentifier {
    return [[[self rac_GET:[NSString stringWithFormat:@"/v1/account/%@/audio/%d", accountIdentifier, audioID.intValue] parameters:[self requestParametersWithParameters:nil]]
             	cb_deserializeArrayWithClient:self keyPath:@"data"]
            	setNameWithFormat:@"Get audio track (accountID: %@, audioID: %d)", accountIdentifier, audioID.intValue];
}



// Figure out MIME type based on extension
static inline NSString * SBAudioContentTypeForPathExtension(NSString *extension, BOOL *supportedAudioUpload) {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    
    if (!contentType && [extension isEqualToString:@"flac"]) {
        contentType = @"audio/flac";
    }
    
    if (supportedAudioUpload) {
        *supportedAudioUpload = contentType != nil;
    }
    
    return contentType;
}

- (RACSignal *)uploadAudioData:(NSData *)data
                     withTitle:(NSString *)title
                      fileName:(NSString *)fileName
                     toAccount:(SBAccount *)account
                progressSignal:(RACSignal **)progressSignal {
    NSParameterAssert(data);
    NSParameterAssert(title);
    NSParameterAssert(fileName);
    NSParameterAssert(account);
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%@/audio", account.identifier]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    BOOL supported;
    NSString *mime = SBAudioContentTypeForPathExtension([fileName.lastPathComponent componentsSeparatedByString:@"."].lastObject, &supported);
    
    if (!supported || !mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }
    
    // create the upload request
    NSError *err;
    
    AFHTTPRequestOperation *op =
    [self fileRequestFromData:data
                         name:@"audio"
                     fileName:fileName
                     mimeType:mime
                          url:endpointLocation
                   parameters:[self requestParametersWithParameters:@{@"title":title}]
                        error:&err
               progressSignal:progressSignal];

    
    if (err) {
        return [RACSignal error:err];
    }

    // use defer to turn "hot" enqueueing into cold signal
    return [[[self enqueueRequestOperation:op]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Upload audio (%@)", fileName];
}

@end
