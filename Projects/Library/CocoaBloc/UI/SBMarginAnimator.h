//
//  SBMarginAnimator.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/12/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAnimator.h"

@interface SBMarginAnimator : SBAnimator

@property (nonatomic) NSArray *constraints;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic) UIEdgeInsets margins;

- (void) addMarginConstraintsToContainerView:(UIView*)containerView modalView:(UIView*)modalView;
- (void) removeMarginConstraintsFromContainerView:(UIView*)containerView;

@end
