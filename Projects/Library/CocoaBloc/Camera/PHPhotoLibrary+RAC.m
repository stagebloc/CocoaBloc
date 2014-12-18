//
//  PHPhotoLibrary+RAC.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "PHPhotoLibrary+RAC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PHPhotoLibrary (RAC)

+ (RACSignal*) rac_requestAccess {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self requestAuthorization:^(PHAuthorizationStatus status) {
            BOOL granted = status == PHAuthorizationStatusAuthorized;
            if (granted) {
                [subscriber sendNext:@(granted)];
                [subscriber sendCompleted];
            } else {
                NSString *errorText;
                switch (status) {
                    case PHAuthorizationStatusDenied:
                        errorText = @"Permission Denied";
                        break;
                    case PHAuthorizationStatusRestricted:
                        errorText = @"Permission Restricted";
                        break;
                    case PHAuthorizationStatusNotDetermined:
                        errorText = @"Permission Undetermined";
                        break;
                    default:
                        break;
                }
                [subscriber sendError:[NSError errorWithDomain:errorText code:101 userInfo:@{@"status":@(status)}]];
            }
        }];
        return nil;
    }];
}

@end
