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
#import "SBVideoUpload.h"

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
                         toAccount:(SBAccount *)account
                         exclusive:(BOOL)exclusive
                        fanContent:(BOOL)fanContent
                    progressSignal:(RACSignal **)progressSignal {
    NSParameterAssert(videoData);
    NSParameterAssert(account);
    NSParameterAssert(title);
    NSParameterAssert(fileName);
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%@/video", account.identifier]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    BOOL supported;
    NSString *mime = SBVideoContentTypeForPathExtension([fileName.lastPathComponent componentsSeparatedByString:@"."].lastObject, &supported);

    if (!supported || !mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[title, @(exclusive), @(fanContent)] forKeys:@[@"title", @"exclusive", @"fan_content"]];
    if (caption) {
        params[@"description"] = caption;
    }
    
    // create the upload request
    NSError *err;
    NSMutableURLRequest *req =
    [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                 URLString:endpointLocation
                                                parameters:[self requestParametersWithParameters:params]
                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                     [formData appendPartWithFileData:videoData name:@"video" fileName:fileName mimeType:mime];
                                 } error:&err];
    
    if (err) {
        return [RACSignal error:err];
    }
    
    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:req success:nil failure:nil];
    if (progressSignal) {
        
        // progress signal is still cold. beautiful!
        *progressSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                [subscriber sendNext:@((double)totalBytesWritten * 100 / totalBytesExpectedToWrite)];
                
                if (totalBytesWritten >= totalBytesExpectedToWrite) {
                    [subscriber sendCompleted];
                }
            }];
            
            return [RACDisposable disposableWithBlock:^{
                [op setUploadProgressBlock:nil];
            }];
        }] setNameWithFormat:@"Upload audio progress (%@)", fileName];
    }
    
    return [[[self enqueueRequestOperation:op]
                cb_deserializeWithClient:self modelClass:[SBVideoUpload class] keyPath:@"data"]
                setNameWithFormat:@"Upload video (%@)", fileName];
}

- (RACSignal *)uploadVideoAtPath:(NSString *)filePath
                           title:(NSString *)title
                         caption:(NSString *)caption
                       toAccount:(SBAccount *)account
                       exclusive:(BOOL)exclusive
                      fanContent:(BOOL)fanContent
                  progressSignal:(RACSignal **)progressSignal {
    NSParameterAssert(filePath);
    NSParameterAssert(title);
    NSParameterAssert(account);
    
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
                                           toAccount:account
                                           exclusive:exclusive
                                          fanContent:fanContent
                                      progressSignal:progressSignal];
                }];
}

@end
