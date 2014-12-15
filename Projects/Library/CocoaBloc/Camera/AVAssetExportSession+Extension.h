//
//  AVAssetExportSession+Extension.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/15/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface AVAssetExportSession (Extension)

- (RACSignal*) exportAsynchronously;

@end
