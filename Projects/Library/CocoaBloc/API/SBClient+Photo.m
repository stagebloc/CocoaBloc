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

static inline NSString * SBPhotoContentTypeForPathExtension(NSData *imageData) {
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xff:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4d:
            return @"image/tiff";
        default:
            return nil;
    }
}

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
               progressSignal:(RACSignal **)progressSignal {
    NSParameterAssert(data);
    NSParameterAssert(title);
    NSParameterAssert(accountIdentifier);
    
    NSString* const fileName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%@/photo", accountIdentifier]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    NSString *mime = SBPhotoContentTypeForPathExtension(data);
    if (!mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }
    
    //should check file type here
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
                                     [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:mime];
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
        }] setNameWithFormat:@"Upload photo %@ progress (%@)", title, fileName];
    }
    
    return [[[self enqueueRequestOperation:op]
             cb_deserializeWithClient:self keyPath:@"data"]
            setNameWithFormat:@"Upload photo %@ to account %@", title, accountIdentifier];
}

- (RACSignal*)uploadPhoto:(UIImage*)image
                    title:(NSString*)title
                  caption:(NSString*)caption
  toAccountWithIdentifier:(NSNumber*)accountIdentifier
                exclusive:(BOOL)exclusive
               fanContent:(BOOL)fanContent
           progressSignal:(RACSignal **)progressSignal {
   
    return [self uploadPhotoData:UIImageJPEGRepresentation(image, 1)
                           title:title
                         caption:caption
         toAccountWithIdentifier:accountIdentifier
                       exclusive:exclusive
                      fanContent:fanContent
                  progressSignal:progressSignal];
}

@end
