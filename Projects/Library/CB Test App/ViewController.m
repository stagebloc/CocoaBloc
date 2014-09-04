//
//  ViewController.m
//  CB Test App
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "ViewController.h"
#import <CocoaBloc/SBActionButton.h>
#import <PureLayout/PureLayout.h>

@interface ViewController () {
    SBActionButton *like;
    SBActionButton *comment;
}

@end

@implementation ViewController
            
- (void)loadView {
    [super loadView];
    
    like = [SBActionButton buttonWithActionType:SBActionTypeLike];
    like.actionCount = 5;
    [self.view addSubview:like];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [like autoCenterInSuperview];
//    [comment autoCenterInSuperview];
}

@end
