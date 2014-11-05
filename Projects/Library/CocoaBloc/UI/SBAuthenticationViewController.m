//
//  SBAuthenticationViewController.m
//  CocoaBloc
//
//  Created by John Heaton on 10/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAuthenticationViewController.h"
#import <RACEXTScope.h>
#import <PureLayout/PureLayout.h>
#import <SBClient.h>
#import <SBClient+Auth.h>

extern NSString *SBClientID;

@implementation SBAuthenticationViewController {
@private
    void (^_signInCompletion)(BOOL success, NSString *token);
    __weak RACSignal *currentlyPresentingSignal;
}

+ (NSURL *)OAuthURL {
    NSAssert(SBClientID != nil, @"You must first set this application's client ID with +[SBClient setClientID:clientSecret:]");
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://stagebloc.com/connect?client_id=%@&response_type=code&redirect_uri=SBiOSAuth://", SBClientID]];
}

- (void)loadView {
    [super loadView];
    
    _webView = [UIWebView new];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  	
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:<#(SEL)#>]
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([webView.request.URL.scheme isEqualToString:@"SBiOSAuth"]) {
#warning ask josh about scheme
        if (_signInCompletion) {
            _signInCompletion(YES, nil);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self.class OAuthURL]]];
}

- (RACSignal *)presentFromParent:(UIViewController *)parent {
    @weakify(self);
    @weakify(parent);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        @strongify(parent);
        
        @weakify(subscriber);
        self->_signInCompletion = ^(BOOL success, NSString *token) {
            @strongify(subscriber);
            
            if (success) {
                SBClient *c = [SBClient new];
                c.token = token;
                [subscriber sendNext:c];
            } else {
//                [subscriber sendError:<#(NSError *)#>]
            }
        };
        
        UIViewController *vc = parent ?: [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:self] animated:YES completion:nil];
        
        @weakify(vc);
        @weakify(self);
    	return [RACDisposable disposableWithBlock:^{
            @strongify(vc);
            @strongify(self);
            
            [self.webView stopLoading];
            [vc dismissViewControllerAnimated:YES completion:nil];
        }];
    }] publish] autoconnect];
}

@end
