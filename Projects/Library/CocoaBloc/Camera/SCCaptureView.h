//
//  SCPreviewView.h
//  StitchCam
//
//  Created by David Skuza on 9/2/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

/**
 * This class is set up so that is can only ever have one capture session per view.
 * This view cannot be recycled for multiple capture sessions. To preview a new session, you must setup another instance of SCCaptureView;
 */

#import <UIKit/UIKit.h>

@import AVFoundation.AVCaptureSession;

@interface SCCaptureView : UIView

- (instancetype)initWithCaptureSession:(AVCaptureSession *)session;

@property (nonatomic, readonly) AVCaptureSession *captureSession;

@end
