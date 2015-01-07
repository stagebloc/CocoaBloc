//
//  SBPushAnimator.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/7/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBMarginAnimator.h"

typedef NS_ENUM(NSUInteger, SBPushAnimatorDirection) {
    SBPushAnimatorDirectionRight = 0,
    SBPushAnimatorDirectionLeft,
    SBPushAnimatorDirectionUp,
    SBPushAnimatorDirectionDown,
};

@interface SBPushAnimator : SBAnimator

@property (nonatomic, assign) SBPushAnimatorDirection direction;

@end
