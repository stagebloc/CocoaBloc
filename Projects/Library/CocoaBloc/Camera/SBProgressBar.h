//
//  SCProgressBarView.h
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBProgressBar;

typedef NS_ENUM(NSUInteger, SBProgressState) {
    SBProgressStateStopped,
    SBProgressStatePaused,
    SBProgressStateStarted
};

@protocol SBProgressBarDelegate <NSObject>
@optional

/*
 * Called when timer is started
 * @progressBar is the progressBar calling the method
 */
- (void) progressBarDidStart:(SBProgressBar*)progressBar;

/*
 * Called when timer is paused
 * @progressBar is the progressBar calling the method
 */
- (void) progressBarDidPause:(SBProgressBar*)progressBar;

/*
 * Called when timer is stopped either manually or when it reaches the set max value
 * @progressBar is the progressBar calling the method
 * @time is the total record time in seconds
 */
- (void) progressBarDidStop:(SBProgressBar*)progressBar withTime:(NSTimeInterval)time;
@end

@interface SBProgressBar : UIView

@property (nonatomic) UIView *progressView;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, readonly) CGFloat minValue;

/*
 Not readonly for Reactive Cocoa reasons
 DO NOT modify this variable outside this class
 */
@property (nonatomic) NSTimeInterval timeElapsed;

@property (nonatomic, assign, readonly) SBProgressState state;

@property (nonatomic, assign) id<SBProgressBarDelegate> delegate;

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

- (BOOL) start;
- (BOOL) pause;
- (BOOL) stop;

@end