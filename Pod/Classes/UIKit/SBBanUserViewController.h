//
//  SBBanUserViewController.h
//  Pods
//
//  Created by David Warner on 7/1/15.
//
//

#import <UIKit/UIKit.h>
#import "SBPlaceholderTextView.h"

@protocol SBBanUserViewControllerDelegate;

@interface SBBanUserViewController : UIViewController

@property (nonatomic) SBPlaceholderTextView *reasonTextView;

@property (nonatomic, assign) id<SBBanUserViewControllerDelegate> delegate;

@end

@protocol SBBanUserViewControllerDelegate <NSObject>
- (void)banUserViewControllerCancelled:(SBBanUserViewController *)controller;
- (void)banUserViewControllerFinishedWithReason:(NSString *)reason;
@end
