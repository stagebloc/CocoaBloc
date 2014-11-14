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

- (void)captureImageWithCompletion:(void(^)(UIImage* image))completion
{
    AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    connection.videoMirrored = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.output captureStillImageAsynchronouslyFromConnection:connection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (!error)
        {
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
            if (weakSelf.aspectRatio == SBCameraAspectRatio1_1) {
                resizeRect = CGRectMake(x, (resizeRect.size.height/CGRectGetHeight([UIScreen mainScreen].bounds)) * 44.0, resizeRect.size.width, resizeRect.size.width);
            }
            
            UIImage *image = [rawImage resizeImageToRect:resizeRect];
            weakSelf.image = image;
            if (image) {
                if (completion) {
                    completion(image);
                }
            } else if (completion) {
                completion(nil);
            }
        } else {
            if (completion)
                completion(nil);
        }
    }];
}


@end
