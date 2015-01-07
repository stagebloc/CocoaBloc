//
//  SBBottomViewContrainer.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBDraggableView.h"

@class SBBottomViewContrainer;

typedef void (^SBBottomViewContrainerCustomAnimations)(CGPoint velocity, BOOL shouldHide);

@interface SBBottomViewContrainer : SBDraggableView

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, copy) void (^stoppedMovingAnimations)(BOOL shouldHide);
@property (nonatomic, copy) void (^stoppedMovingCompletion)(BOOL finished);

//default = 200
@property (nonatomic, assign) CGFloat height;

- (BOOL) isVisible;

- (void) toggleHidden;
- (void) toggleHiddenWithCustomAnimations:(void(^)(BOOL shouldHide))customAnimations completion:(void(^)(BOOL finished))completion;

- (void) adjustConstraintsHidden:(BOOL)isHidden;

@end
