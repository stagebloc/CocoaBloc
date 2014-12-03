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

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, readonly) CGFloat minValue;

@property (nonatomic, strong, readonly) NSMutableSet *stopValues;

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

//Adds the current @value attribute to @stopValues
- (void) addCurrentValueToStopValues;

- (void) addStopValuesObject:(NSNumber *)value;
- (void) removeStopValuesObject:(NSNumber *)value;

@end