//
//  SBBanUserViewController.m
//  Pods
//
//  Created by David Warner on 7/1/15.
//
//

#import "SBBanUserViewController.h"
#import <PureLayout.h>
#import <ReactiveCocoa.h>

@implementation SBBanUserViewController

- (void)loadView {
    [super loadView];

    self.view.backgroundColor = [UIColor whiteColor];

    _reasonTextView = [[SZTextView alloc] init];
    _reasonTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 10, 10);
    _reasonTextView.font = [UIFont systemFontOfSize:18];
    _reasonTextView.placeholder = @"Enter a reason for banning this user...";
    [self.view addSubview:_reasonTextView];

    [_reasonTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_reasonTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:10];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [self.reasonTextView.rac_textSignal map:^id(NSString *val) {
        return @(val.length > 0);
    }];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.reasonTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.reasonTextView resignFirstResponder];
}

- (void)submit {
    if ([self.delegate respondsToSelector:@selector(banUserViewControllerFinishedWithReason:)]) {
        [self.delegate banUserViewControllerFinishedWithReason:_reasonTextView.text];
    }
}

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(banUserViewControllerCancelled:)]) {
        [self.delegate banUserViewControllerCancelled:self];
    }
}

@end
