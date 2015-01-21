//
//  AFHTTPRequestOperationManager+File.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/20/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "AFHTTPRequestOperationManager+File.h"

@implementation AFHTTPRequestOperationManager (File)

- (AFHTTPRequestOperation*) fileRequestFromData:(NSData*)data
                                           name:(NSString*)name
                                       fileName:(NSString*)fileName
                                       mimeType:(NSString*)mime
                                            url:(NSString*)url
                                     parameters:(NSDictionary*)parameters
                                          error:(NSError**)error
                                  progressSignal:(RACSignal**)progressSignal {
    // create the upload request
    NSMutableURLRequest *req =
    [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                 URLString:url
                                                parameters:parameters
                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                     [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mime];
                                 } error:error];
    
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
        }] setNameWithFormat:@"Upload file progress %@", url];
    }

    return op;
}


@end
