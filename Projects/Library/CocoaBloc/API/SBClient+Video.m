//
//  SBClient+Video.m
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Video.h"
#import "SBClient+Private.h"

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
                         toAccount:(SBAccount *)account
                    progressSignal:(RACSignal **)progressSignal {
    NSParameterAssert(videoData);
    NSParameterAssert(account);
    NSParameterAssert(fileName);
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%@/video", account.identifier]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    BOOL supported;
    NSString *mime = SBVideoContentTypeForPathExtension([fileName.lastPathComponent componentsSeparatedByString:@"."].lastObject, &supported);

    if (!supported || !mime) {
#warning make this a real error
        return [RACSignal error:[NSError errorWithDomain:@"temp" code:1 userInfo:nil]];
    }
    
    // create the upload request
    NSError *err;
    NSMutableURLRequest *req =
    [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                 URLString:endpointLocation
                                                parameters:[self requestParametersWithParameters:nil]
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
                map:^id(NSDictionary *response) {
                    return response;
                }]
                setNameWithFormat:@"Upload video (%@)", fileName];
}

- (RACSignal *)uploadVideoAtPath:(NSString *)filePath
                       toAccount:(SBAccount *)account
                  progressSignal:(RACSignal **)progressSignal {
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
                                            fileName:filePath
                                           toAccount:account
                                      progressSignal:progressSignal];
                }];
}

@end
