//
//  SBFlagViewController.m
//  CocoaBloc
//
//  Created by John Heaton on 2/4/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBFlagViewController.h"
#import <PureLayout.h>
#import <ReactiveCocoa.h>
#import "SBClient+Comment.h"

@interface SBFlagViewController ()

@property (nonatomic) UISegmentedControl *typePicker;
@property (nonatomic) UITextView *reasonTextView;
@property (nonatomic) NSDictionary *titleToReasonMap;

@end


@implementation SBFlagViewController

- (void)loadView {
    [super loadView];
    
    _titleToReasonMap = @{@"Offensive" : SBAPIMethodParameterFlagContentValueOffensive,
                          @"Prejudice" : SBAPIMethodParameterFlagContentValuePrejudice,
                          @"Copyright" : SBAPIMethodParameterFlagContentValueCopyright,
                          @"Duplicate" : SBAPIMethodParameterFlagContentValueDuplicate
                          };
    
    _typePicker = [[UISegmentedControl alloc] initWithItems:@[@"Offensive", @"Prejudice", @"Copyright", @"Duplicate"]];
    _typePicker.selectedSegmentIndex = 0;
    _typePicker.backgroundColor = [UIColor clearColor];
    
    _reasonTextView = [[UITextView alloc] init];
    _reasonTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 10, 10);
    _reasonTextView.font = [UIFont systemFontOfSize:18];
    
    [self.view addSubview:_typePicker];
    [self.view addSubview:_reasonTextView];
    
    [_typePicker autoPinToTopLayoutGuideOfViewController:self withInset:10];
    [_typePicker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
    [_typePicker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
    [_reasonTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_reasonTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_typePicker withOffset:10];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [self.reasonTextView.rac_textSignal map:^id(NSString *val) {
        return @(val.length > 0);
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)submit {
    if ([self.delegate respondsToSelector:@selector(flagViewControllerFinishedWithType:reason:)]) {
        [self.delegate flagViewControllerFinishedWithType:_titleToReasonMap.allValues[_typePicker.selectedSegmentIndex] reason:_reasonTextView.text];
    }
}

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(flagViewControllerCancelled:)]) {
        [self.delegate flagViewControllerCancelled:self];
    }
}

@end
