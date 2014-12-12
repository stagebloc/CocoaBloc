//
//  AVCaptureDevice+RAC.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AVCaptureDevice+RAC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation AVCaptureDevice (RAC)

+ (RACSignal*) rac_requestAccessForMediaType:(NSString*)mediaType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted) {
                [subscriber sendNext:@(granted)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ permission denied", mediaType] code:101 userInfo:@{@"type":mediaType}]];
            }
        }];
        return nil;
    }];
}

+ (RACSignal*) rac_requestAccessForVideoMediaType {
    return [self rac_requestAccessForMediaType:AVMediaTypeVideo];
}
+ (RACSignal*) rac_requestAccessForAudioMediaType {
    return [self rac_requestAccessForMediaType:AVMediaTypeAudio];
}

@end
