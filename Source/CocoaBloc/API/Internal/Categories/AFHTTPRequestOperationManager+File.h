//
//  AFHTTPRequestOperationManager+File.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/20/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AFHTTPRequestOperationManager (File)

- (AFHTTPRequestOperation*) fileRequestFromData:(NSData*)data
                                           name:(NSString*)name
                                       fileName:(NSString*)fileName
                                       mimeType:(NSString*)mime
                                            url:(NSString*)url
                                     parameters:(NSDictionary*)parameters
                                          error:(NSError**)error
                                 progressSignal:(RACSignal**)progressSignal;

@end
