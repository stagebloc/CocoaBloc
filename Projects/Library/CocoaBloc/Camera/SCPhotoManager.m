//
//  SCPhotoManager.m
//  StitchCam
//
//  Created by David Skuza on 9/3/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCPhotoManager.h"
#import "SCCapturing.h"
#import "SCReviewController.h"

@implementation SCPhotoManager

- (id)initWithCaptureSession:(AVCaptureSession *)session {
    if (self = [super initWithCaptureSession:session]) {
        self.aspectRatio = SCCameraAspectRatio4_3;
    }
    return self;
}

- (void)captureImage
{
    AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    connection.videoMirrored = !self.cameraType;
    
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
            if (weakSelf.aspectRatio == SCCameraAspectRatio1_1) {
                resizeRect = CGRectMake(x, (resizeRect.size.height/CGRectGetHeight([UIScreen mainScreen].bounds)) * 44.0, resizeRect.size.width, resizeRect.size.width);
            }
            
            weakSelf.image = [self resizeImage:rawImage inRect:resizeRect];
            if (weakSelf.image) {
                if ([self.delegate respondsToSelector:@selector(photoManager:capturedImage:)])
                    [self.delegate photoManager:self capturedImage:weakSelf.image];
            }
        } else {
            // Error handling
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image inRect:(CGRect)rect;
{
    if (UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    [image drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark - Override

- (void)setCameraType:(SCCameraType)cameraType
{
    [super setCameraType:cameraType];

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

@end
