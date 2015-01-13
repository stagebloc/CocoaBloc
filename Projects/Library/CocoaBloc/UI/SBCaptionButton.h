//
//  SBCaptionButton.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBImageControl.h"

@interface SBCaptionButton : SBImageControl

@property (nonatomic) UILabel *captionLabel;

@property (nonatomic) UIImage *onImage;
@property (nonatomic) UIImage *offImage;

@property (nonatomic, assign, getter=isOn) BOOL on;

@end
