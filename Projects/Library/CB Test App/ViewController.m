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
#import <CocoaBloc/SBLoadingImageView.h>

@interface ViewController () {
    SBActionButton *like;
    SBActionButton *comment;
    SBAnimationContainerView *container;
    SBLoadingImageView *image;
}

@end

@implementation ViewController
            
- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    image = [[SBLoadingImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    container = [SBAnimationContainerView contain:image];
    
    [self.view addSubview:container];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [container autoCenterInSuperview];
    [container autoSetDimensionsToSize:CGSizeMake(100, 100)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [image downloadImageAtURL:[NSURL URLWithString:@"http://www.picturesnew.com/media/images/a.png"]];
}

@end
