//
//  SBBanUserViewController.h
//  Pods
//
//  Created by David Warner on 7/1/15.
//
//

#import <UIKit/UIKit.h>
#import <SZTextView/SZTextView.h>

@protocol SBBanUserViewControllerDelegate;

@interface SBBanUserViewController : UIViewController

@property (nonatomic) SZTextView *reasonTextView;

@property (nonatomic, assign) id<SBBanUserViewControllerDelegate> delegate;

@end

@protocol SBBanUserViewControllerDelegate <NSObject>
- (void)banUserViewControllerCancelled:(SBBanUserViewController *)controller;
- (void)banUserViewControllerFinishedWithReason:(NSString *)reason;
@end
