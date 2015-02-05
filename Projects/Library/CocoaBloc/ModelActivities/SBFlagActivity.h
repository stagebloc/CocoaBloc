//
//  SBFlagActivity.h
//  Pods
//
//  Created by John Heaton on 2/2/15.
//
//

#import <UIKit/UIKit.h>
#import "SBClient.h"
#import "SBFlagViewController.h"

@protocol SBFlagActivityDelegate;

@interface SBFlagActivity : UIActivity

- (instancetype)initWithClient:(SBClient *)client;

@property (nonatomic, assign) id<SBFlagActivityDelegate> delegate;

@end

@protocol SBFlagActivityDelegate <NSObject>

- (void)flagActivity:(SBFlagActivity *)activity willDisplayViewController:(SBFlagViewController *)viewController;

@end

extern NSString *const SBFlagActivityType;