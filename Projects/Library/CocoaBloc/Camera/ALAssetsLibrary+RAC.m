//
//  ALAssetsLibrary+RAC.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "ALAssetsLibrary+RAC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation ALAssetsLibrary (RAC)

- (RACSignal *)fetchGroupsWithTypes:(ALAssetsGroupType)types {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [subscriber sendNext:group];
            } else {
                [subscriber sendCompleted];
            }
        } failureBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

+ (BOOL)isThereAuthStatusDetermined:(NSError **)error {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusAuthorized:
            if (error) { *error = nil; }
            return YES;
        case ALAuthorizationStatusDenied:
            if (error) { *error = [NSError errorWithDomain:@"Access Denied" code:101 userInfo:nil]; }
            return YES;
        case ALAuthorizationStatusRestricted:
            if (error) { *error = [NSError errorWithDomain:@"Access Restricted" code:101 userInfo:nil]; }
            return YES;
        default:
            if (error) { *error = nil; }
            return NO;
    }
}

+ (RACSignal *)rac_requestAccess {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSError *error = nil;
        if (![self isThereAuthStatusDetermined:&error]) {
            //access not determined
            [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                *stop = YES; //access enabled
            } failureBlock:^(NSError *e) {
                [subscriber sendError:error];
            }];
        } else if (!error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        
        if (error) {
            [subscriber sendError:error];
            return nil;
        }
        
        return nil;
    }];
}

@end
