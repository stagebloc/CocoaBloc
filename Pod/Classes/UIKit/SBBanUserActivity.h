//
//  SBBanUserActivity.h
//  Pods
//
//  Created by David Warner on 7/1/15.
//
//

#import <UIKit/UIKit.h>
#import "SBClient.h"
#import "SBBanUserViewController.h"

@protocol SBBanUserActivityDelegate;

@interface SBBanUserActivity : UIActivity

- (instancetype)initWithClient:(SBClient *)client
                        userID:(NSNumber* )userID
                     accountID:(NSNumber *)accountID;

@property (nonatomic, assign) id<SBBanUserActivityDelegate> delegate;

@end

@protocol SBBanUserActivityDelegate <NSObject>

- (void)banActivity:(SBBanUserActivity *)activity willDisplayViewController:(SBBanUserViewController *)viewController;

@end

extern NSString *const SBBanUserActivityType;
