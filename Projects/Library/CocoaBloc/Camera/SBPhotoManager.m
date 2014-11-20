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

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation SBPhotoManager

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super initWithCaptureSession:session]) {
        self.aspectRatio = SBCameraAspectRatio4_3;
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

- (RACSignal*)captureImage
{
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        connection.videoMirrored = NO;

        [self.output captureStillImageAsynchronouslyFromConnection:connection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            @strongify(self);
            if (error) {
                [subscriber sendError:[NSError errorWithDomain:@"Cannot create image" code:101 userInfo:nil]];
                return;
            }
            
            UIImage *rawImage = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer]];
            
            CGFloat screenAspectRatio = [[UIScreen mainScreen] bounds].size.height/[[UIScreen mainScreen] bounds].size.width;
            CGFloat imageAspectRatio = rawImage.size.height/rawImage.size.width;
            CGFloat resizedImageWidth;
            CGFloat resizedImageHeight;
            CGFloat x;
            CGFloat y;
            
            if (imageAspectRatio/screenAspectRatio < 1) {
                // This one should always run since all apple device screens have a higher aspect ratio than the raw image aspect ratio...
                resizedImageWidth = (imageAspectRatio/screenAspectRatio) * rawImage.size.width;
                resizedImageHeight = rawImage.size.height;
                x = (rawImage.size.width - resizedImageWidth)/2;
                y = 0.f;
            } else if (imageAspectRatio/screenAspectRatio > 1) {
                // ...but you can have this too, I guess?
                resizedImageWidth = rawImage.size.width;
                resizedImageHeight = (screenAspectRatio/imageAspectRatio) * rawImage.size.height;
                x = 0.f;
                y = (rawImage.size.height - resizedImageHeight)/2;
            } else {
                resizedImageWidth = rawImage.size.width;
                resizedImageHeight = rawImage.size.height;
                x = 0.f;
                y = 0.f;
            }
            
            CGRect resizeRect = CGRectMake(x, y, resizedImageWidth, resizedImageHeight);
            if (self.aspectRatio == SBCameraAspectRatio1_1) {
                resizeRect = CGRectMake(x, (resizeRect.size.height/CGRectGetHeight([UIScreen mainScreen].bounds)) * 44.0, resizeRect.size.width, resizeRect.size.width);
            }
            
            UIImage *image = [rawImage resizeImageToRect:resizeRect];
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
