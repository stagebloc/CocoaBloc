//
//  SBActionButton.m
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBActionButton.h"

@implementation SBActionButton

- (void)setType:(SBActionButtonType)type {
    NSString *normalImageName = nil;
    NSString *selectedImageName = nil;
    
    switch (type) {
        case SBActionButtonTypeLike:
            normalImageName = @"action_like";
            selectedImageName = @"action_like_active";
            
            break;
        case SBActionButtonTypeComment:
            normalImageName = @"action_";
            
            break;
            
        default: [NSException raise:@"SBActionButtonException" format:@"Unsupported button type: %ld", type];
    }
    
    [self setImage:normalImageName forState:UIControlStateNormal];
    [self setImage:selectedImageName forState:UIControlStateSelected];
}

@end
