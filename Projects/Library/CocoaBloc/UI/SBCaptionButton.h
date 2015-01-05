//
//  SBCaptionButton.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBCaptionButton : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *captionLabel;

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;

@property (nonatomic, assign) BOOL on;

@end
