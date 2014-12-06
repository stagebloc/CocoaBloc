//
//  SCPhotoManager.m
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBPhotoManager.h"
#import "SBReviewController.h"
#import "UIImage+Resize.h"
#import "UIDevice+Orientation.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation SBPhotoManager

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super initWithCaptureSession:session]) {
        self.aspectRatio = SBCameraAspectRatioNormal;
        self.devicePosition = AVCaptureDevicePositionBack;
        
        if (!self.output || ![self.captureSession.outputs containsObject:self.output]) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeOutput:_output];
            self.output = [AVCaptureStillImageOutput new];
            if ([self.captureSession canAddOutput:_output]) {
                [self.captureSession addOutput:_output];
            }
            [self.captureSession commitConfiguration];
        }
        
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (RACSignal*)captureImage {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
        AVCaptureVideoOrientation orientation = [[UIDevice currentDevice] videoOrientation];
        connection.videoOrientation = (NSInteger)orientation == -1 ? AVCaptureVideoOrientationPortrait : orientation;
        connection.videoMirrored = NO;

        [self.output captureStillImageAsynchronouslyFromConnection:connection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            @strongify(self);
            if (error) {
                [subscriber sendError:[NSError errorWithDomain:@"Cannot create image" code:101 userInfo:nil]];
                return;
            }
            
            UIImage *image = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer]];
            if (self.aspectRatio == SBCameraAspectRatioSquare) {
                image = [image resizeToSquare];
            }
            
            self.image = image;
            if (image) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"Cannot create image" code:101 userInfo:nil]];
            }
        }];
        
        return nil;
    }];
    
}


@end
