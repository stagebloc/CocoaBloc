//
//  SBClient+Video.m
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Video.h"
#import "RACSignal+JSONDeserialization.h"
#import "SBClient+Private.h"
#import "SBVideo.h"
#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import "AFHTTPRequestOperationManager+File.h"

// Figure out MIME type based on extension
static inline NSString * SBVideoContentTypeForPathExtension(NSString *extension, BOOL *supportedVideoUpload) {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    
    if (supportedVideoUpload) {
        *supportedVideoUpload = contentType != nil;
    }
    
    return contentType;
}

@implementation SBClient (Video)

- (RACSignal *)uploadVideoWithData:(NSData *)videoData
                          fileName:(NSString *)fileName
                             title:(NSString *)title
                           caption:(NSString *)caption
           toAccountWithIdentifier:(NSNumber *)accountIdentifier
                         exclusive:(BOOL)exclusive
                        fanContent:(BOOL)fanContent
                    progressSignal:(RACSignal **)progressSignal
                        parameters:(NSDictionary *)parameters {
    NSParameterAssert(videoData);
    NSParameterAssert(accountIdentifier);
    NSParameterAssert(title);
    NSParameterAssert(fileName);
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%@/video", accountIdentifier]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    BOOL supported;
    NSString *mime = SBVideoContentTypeForPathExtension([fileName.lastPathComponent componentsSeparatedByString:@"."].lastObject, &supported);

    if (!supported || !mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }
    
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
    [self fileRequestFromData:videoData
                         name:@"video"
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
                setNameWithFormat:@"Upload video (%@)", fileName];
}

- (RACSignal *)uploadVideoAtPath:(NSString *)filePath
                           title:(NSString *)title
                         caption:(NSString *)caption
         toAccountWithIdentifier:(NSNumber *)accountIdentifier
                       exclusive:(BOOL)exclusive
                      fanContent:(BOOL)fanContent
                  progressSignal:(RACSignal **)progressSignal
                      parameters:(NSDictionary *)parameters {
    NSParameterAssert(filePath);
    NSParameterAssert(title);
    NSParameterAssert(accountIdentifier);
    
    RACSignal *(^signalFromPath)() = ^RACSignal * {
        NSData *fileData;
        NSError *error;
        
        fileData = [NSData dataWithContentsOfFile:filePath options:0 error:&error];
        if (error || !fileData) {
            return [RACSignal error:error];
        }
        
        return [RACSignal return:fileData];
    };
    
    return [[RACSignal defer:signalFromPath]
                flattenMap:^RACStream *(NSData *fileData) {
                    return [self uploadVideoWithData:fileData
                                            fileName:filePath.lastPathComponent
                                               title:title
                                             caption:caption
                             toAccountWithIdentifier:accountIdentifier
                                           exclusive:exclusive
                                          fanContent:fanContent
                                      progressSignal:progressSignal
                                          parameters:parameters];
                }];
}

- (RACSignal *)trackVideoEvent:(NSString *)event
               videoIdentifier:(NSNumber *)videoIdentifier
             accountIdentifier:(NSNumber *)accountIdentifier {
    NSParameterAssert(event);
    NSParameterAssert(videoIdentifier);
    NSParameterAssert(accountIdentifier);

    NSDictionary *params = @{@"event" : event};

    return [[[self rac_POST:[NSString stringWithFormat:@"account/%@/video/%@/stats", accountIdentifier, videoIdentifier] parameters:[self requestParametersWithParameters:params]] cb_deserializeWithClient:self keyPath:@"data"] setNameWithFormat:@"Post video event (%@) to account (%@)", event, accountIdentifier];
}

@end
