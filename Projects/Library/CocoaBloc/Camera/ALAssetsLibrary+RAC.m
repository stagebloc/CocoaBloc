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

- (RACSignal*) fetchGroupsWithTypes:(ALAssetsGroupType)types {
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

@end
