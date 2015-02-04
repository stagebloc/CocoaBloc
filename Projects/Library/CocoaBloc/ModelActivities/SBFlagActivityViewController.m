//
//  SBFlagActivityViewController.m
//  CocoaBloc
//
//  Created by John Heaton on 2/3/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBFlagActivityViewController.h"
#import <PureLayout/PureLayout.h>

@interface SBFlagActivityViewController ()
@property (nonatomic) UISegmentedControl *typePicker;
@property (nonatomic) UITextView *reasonTextView;
@end

@implementation SBFlagActivityViewController

- (void)loadView {
    [super loadView];
    
    self.typePicker = [[UISegmentedControl alloc] initWithItems:@[@"Duplicate", @"Offensive", @"Prejudice", @"Copyright"]];
    
    self.reasonTextView = [UITextView new];
    
    [self.view addSubview:self.typePicker];
    [self.view addSubview:self.reasonTextView];
    
    [self.typePicker autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) excludingEdge:ALEdgeBottom];
    [self.reasonTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.reasonTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typePicker withOffset:10];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

@end
