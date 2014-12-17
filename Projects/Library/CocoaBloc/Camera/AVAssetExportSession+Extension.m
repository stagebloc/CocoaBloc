//
//  AVAssetExportSession+Extension.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/15/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AVAssetExportSession+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation AVAssetExportSession (Extension)

+ (instancetype) exportSessionWithAsset:(AVAsset *)asset presetName:(NSString *)presetName outputURL:(NSURL*)outputURL {
    AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:asset presetName:presetName];
    exporter.outputURL = outputURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    return exporter;
}

- (RACSignal*) exportAsynchronously {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self exportAsynchronouslyWithCompletionHandler:^{
            NSError *error = self.error;
            switch([self status]) {
                case AVAssetExportSessionStatusFailed:
                    [subscriber sendError:error];
                    break;
                case AVAssetExportSessionStatusCancelled:
                    [subscriber sendError:[NSError errorWithDomain:@"Export cancelled" code:100 userInfo:nil]];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    [subscriber sendNext:self.outputURL];
                    [subscriber sendCompleted];
                    break;
                default:
                    [subscriber sendError:[NSError errorWithDomain:@"Unknown export error" code:100 userInfo:nil]];
                    break;
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [self cancelExport];
        }];
    }];
}

@end
