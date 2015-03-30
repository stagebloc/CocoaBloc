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
#import "SBClient.h"
#import "SBClient+Auth.h"

extern NSString *SBClientID, *SBRedirectURI;

@implementation SBAuthenticationViewController {
@private
    RACSubject *webViewSubject;
}

- (instancetype)init {
    if ((self = [super init])) {
        webViewSubject = [RACSubject new];
    }
    return self;
}

+ (NSURL *)OAuthURL {
    NSAssert(SBClientID != nil && SBRedirectURI != nil, @"You must first set this application's authentication details with +[SBClient setClientID:clientSecret:redirectURI:]. A valid client ID and redirect URI are required for this view controller to function.");
    
    NSLog(@"%@", [NSString stringWithFormat:@"http://stagebloc.com/connect?client_id=%@&response_type=code&redirect_uri=%@", SBClientID, SBRedirectURI]);
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://stagebloc.com/connect?client_id=%@&response_type=code&redirect_uri=%@", SBClientID, SBRedirectURI]];
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
  	
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(selfDismiss)];
}

- (void)selfDismiss {
    [webViewSubject sendCompleted];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:SBRedirectURI]) {
        for (NSString *param in [request.URL.query componentsSeparatedByString:@"&"]) {
            NSArray *parts = [param componentsSeparatedByString:@"="];
            if (parts.count == 2 && [parts.firstObject isEqualToString:@"code"]) {
                [webViewSubject sendNext:parts[1]];
            }
        }
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webViewSubject sendError:error];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self.class OAuthURL]]];
}

- (RACSignal *)presentFromParent:(UIViewController *)parent {
    @weakify(self);
    @weakify(parent);
    
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        @strongify(parent);
        
        @weakify(subscriber);
        RACDisposable *d = [webViewSubject subscribeNext:^(NSString *authorizationCode) {
            @strongify(subscriber);
        
            [subscriber sendNext:authorizationCode];
        }];
        
        UIViewController *vc = parent ?: [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:self] animated:YES completion:nil];
        
        @weakify(vc);
        @weakify(self);
        return [RACCompoundDisposable compoundDisposableWithDisposables:@[d, [RACDisposable disposableWithBlock:^{
            @strongify(vc);
            @strongify(self);
            
            [self.webView stopLoading];
            [vc dismissViewControllerAnimated:YES completion:nil];
        }]]];
    }] takeUntil:self.rac_willDeallocSignal] publish] autoconnect];
}

@end
