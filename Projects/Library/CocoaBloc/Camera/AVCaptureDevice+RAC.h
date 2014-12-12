//
//  AVCaptureDevice+RAC.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class RACSignal;

@interface AVCaptureDevice (RAC)

+ (RACSignal*) rac_requestAccessForMediaType:(NSString*)mediaType;

+ (RACSignal*) rac_requestAccessForVideoMediaType;
+ (RACSignal*) rac_requestAccessForAudioMediaType;

@end
