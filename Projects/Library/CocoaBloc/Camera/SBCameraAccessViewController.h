//
//  SBCameraAccessViewController.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBCameraAccessViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *detailsButton;
@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, copy) NSString *mediaType;

- (instancetype) initWithMediaTypeDenied:(NSString*)mediaType;

@end
