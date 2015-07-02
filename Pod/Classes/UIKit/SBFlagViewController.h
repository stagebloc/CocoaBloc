//
//  SBFlagViewController.h
//  CocoaBloc
//
//  Created by John Heaton on 2/4/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SZTextView/SZTextView.h>

@protocol SBFlagViewControllerDelegate;

@interface SBFlagViewController : UIViewController

@property (nonatomic) UISegmentedControl *typePicker;
@property (nonatomic) SZTextView *reasonTextView;

@property (nonatomic, assign) id<SBFlagViewControllerDelegate> delegate;

@end


@protocol SBFlagViewControllerDelegate <NSObject>
- (void)flagViewControllerCancelled:(SBFlagViewController *)controller;
- (void)flagViewControllerFinishedWithType:(NSString *)type reason:(NSString *)reason;
@end