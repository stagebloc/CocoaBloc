//
//  SCProgressBarView.h
//  StitchCam
//
//  Created by Mark Glagola on 10/31/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCProgressBar;

typedef NS_ENUM(NSUInteger, SCProgressState) {
    SCProgressStateStopped,
    SCProgressStatePaused,
    SCProgressStateStarted
};

@protocol SCProgressBarDelegate <NSObject>
@optional

/*
 * Called when timer is started
 * @progressBar is the progressBar calling the method
 */
- (void) progressBarDidStart:(SCProgressBar*)progressBar;

/*
 * Called when timer is paused
 * @progressBar is the progressBar calling the method
 */
- (void) progressBarDidPause:(SCProgressBar*)progressBar;

/*
 * Called when timer is stopped either manually or when it reaches the set max value
 * @progressBar is the progressBar calling the method
 * @time is the total record time in seconds
 */
- (void) progressBarDidStop:(SCProgressBar*)progressBar withTime:(NSTimeInterval)time;
@end

@interface SCProgressBar : UIView

@property (nonatomic) UIView *progressView;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, readonly) CGFloat minValue;

@property (nonatomic, assign, readonly) SCProgressState state;

@property (nonatomic, assign) id<SCProgressBarDelegate> delegate;

- (id) initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

- (BOOL) start;
- (BOOL) pause;
- (BOOL) stop;


@end