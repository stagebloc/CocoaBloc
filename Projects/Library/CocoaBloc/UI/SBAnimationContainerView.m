//
//  SBAnimationContainerView.m
//  CocoaBloc
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAnimationContainerView.h"

@implementation SBAnimationContainerView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.animationView) {
        self.animationView.center = self.center;
    }
}

@end
