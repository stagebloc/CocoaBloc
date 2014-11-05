//
//  SBAuthenticationViewController.h
//  CocoaBloc
//
//  Created by John Heaton on 10/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SBAuthenticationViewController : UIViewController <UIWebViewDelegate>

+ (NSURL *)OAuthURL;

@property (nonatomic, readonly) UIWebView *webView;

// Subscriptions to this signal are shared into one
// multicasted subscription. Subscription also presents the controller
// as a modal from the parent.
// Cancelling the subscription will dismiss it, and it will send
// an SBClient object that is authenticated, or complete if not.
- (RACSignal *)presentFromParent:(UIViewController *)parent;

@end
