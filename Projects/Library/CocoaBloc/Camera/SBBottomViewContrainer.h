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

@protocol SBBottomViewContrainerDelegate <SBDraggableViewDelegate>
@optional
- (SBBottomViewContrainerCustomAnimations) bottomViewContainerDidStopMoving:(SBBottomViewContrainer*)view;
@end

@interface SBBottomViewContrainer : SBDraggableView

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, weak) id<SBBottomViewContrainerDelegate>dragDelegate;

//default = 200
@property (nonatomic, assign) CGFloat height;


- (void) toggleHidden;
- (void) toggleHiddenWithCustomAnimations:(void(^)(BOOL shouldHide))customAnimations completion:(void(^)(BOOL finished))completion;

- (void) adjustConstraintsHidden:(BOOL)isHidden;

-(void)animateHidden:(BOOL)hidden duration:(NSTimeInterval)duration customAnimations:(void(^)(CGFloat toValue))customAnimations completion:(void(^)(BOOL finished))completion;

@end
