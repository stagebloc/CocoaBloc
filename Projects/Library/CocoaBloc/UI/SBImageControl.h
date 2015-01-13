//
//  SBImageControl.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBImageControl : UIControl

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) CALayer *maskLayer;

- (void) initDefaults;


@end
