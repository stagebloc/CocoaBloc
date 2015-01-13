//
//  SBCameraAccessViewController.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 This controller is responsible for handling if the user has denied the app access `AVMediaTypeAudio` & `AVMediaTypeCamera`. It will present instructions to reenable access if the user desires
 */
@interface SBCameraAccessViewController : UIViewController

@property (nonatomic) UIButton *dismissButton;
@property (nonatomic, copy) NSString *mediaType;

- (instancetype) initWithMediaTypeDenied:(NSString*)mediaType;

@end
