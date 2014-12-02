//
//  SCProgressBarView.h
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBProgressBar;

@interface SBProgressBar : UIView

@property (nonatomic) UIView *progressView;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, readonly) CGFloat minValue;

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

@end