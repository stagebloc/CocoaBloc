//
//  SBAnimator.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SBAnimatorType) {
    SBAnimatorTypePresent = 0,
    SBAnimatorTypeDismiss = 1,
    SBAnimatorTypePush = 2,
    SBAnimatorTypePop = 3,
};

/*
 This is an abstract class and is meant to be overridden.
 HOWEVER, there is an animation by default that mimics
 the native presentViewController animation.
 */

@interface SBAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) SBAnimatorType type;
@property (nonatomic, assign) NSTimeInterval transitionSpeed;

@end
