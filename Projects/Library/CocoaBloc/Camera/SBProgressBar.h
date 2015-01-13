//
//  SCProgressBarView.h
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SBProgressBarOptions) {
    SBProgressBarOptionsLeftToRight = 1 << 0,
    SBProgressBarOptionsRightToLeft = 1 << 1,
    
    SBProgressBarOptionsHorizontal = 1 << 2,
    SBProgressBarOptionsVertical = 1 << 3
};

@class SBProgressBar;

@interface SBProgressBar : UIView

extern SBProgressBarOptions SBProgressBarOptionsFromOrientation(UIInterfaceOrientation orietnation);

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, readonly) CGFloat minValue;

@property (nonatomic, readonly) NSMutableSet *stopValues;

@property (nonatomic, assign) SBProgressBarOptions options;

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

//Adds the current @value attribute to @stopValues
- (void) addCurrentValueToStopValues;

- (void) addStopValuesObject:(NSNumber *)value;
- (void) removeStopValuesObject:(NSNumber *)value;

@end