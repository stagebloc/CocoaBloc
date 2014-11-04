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


- (id)initWithCaptureSession:(AVCaptureSession *)session
{
    self = [super initWithCaptureSession:session];
    if (self) {
        self.aspectRatioDefault = YES;
    }
    return self;
}

- (BOOL)isFlashModeAvailable:(AVCaptureFlashMode)flashMode
{
    return [self.currentCamera isFlashModeSupported:flashMode];
}

- (BOOL)isFlashModeActive:(AVCaptureFlashMode)flashMode
{
    return [self.currentCamera isFlashActive];
}

- (BOOL)toggleAspectRatio;
{
    return !self.aspectRatioDefault;
}

- (void)captureImage
{
    AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    connection.videoMirrored = !self.cameraType;

    [_output captureStillImageAsynchronouslyFromConnection:connection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (!error) {
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
                if (!self.aspectRatioDefault) {
                    resizeRect = CGRectMake(x, (resizeRect.size.height/CGRectGetHeight([UIScreen mainScreen].bounds)) * 44.0, resizeRect.size.width, resizeRect.size.width);
                }

                _image = [self resizeImage:rawImage inRect:resizeRect];
                    if (_image) {
                        [_delegate performSelector:@selector(imageCaptureCompleted)];
                    }
                } else {
                    // Error handling
                }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self configureOutput];
        });
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
    [self configureOutput];
}

-(void)configureOutput
{
    if (self.captureSession.outputs > 0) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeOutput:_output];
        _output = [AVCaptureStillImageOutput new];
        if ([self.captureSession canAddOutput:_output]) {
            [self.captureSession addOutput:_output];
        }
        [self.captureSession commitConfiguration];
    }
}

-(void)exportMedia
{
//    NSString *URLString = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]]];
//    NSURL *outputURL = [NSURL fileURLWithPath:URLString];
}

@end
