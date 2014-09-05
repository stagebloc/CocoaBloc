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
#import <CocoaBloc/SBAnimationContainerView.h>

@interface ViewController () {
    SBActionButton *like;
    SBActionButton *comment;
    SBAnimationContainerView *container;
}

@end

@implementation ViewController
            
- (void)loadView {
    [super loadView];
    
    container = [SBAnimationContainerView new];
    
    like = [SBActionButton buttonWithActionType:SBActionTypeLike];
    like.actionCount = 5;

    container.animationView = like;
    [self.view addSubview:container];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [container autoCenterInSuperview];
//    [comment autoCenterInSuperview];
}

@end
