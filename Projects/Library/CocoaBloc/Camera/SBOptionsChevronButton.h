//
//  SBOptionsChevronButton.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/5/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBImageControl.h"
#import "SBBottomViewContrainer.h"

@class SBBottomViewContrainer;

/*!
 a button used for controlling a SBBottomViewContrainer instance
 */
@interface SBOptionsChevronButton : SBImageControl <SBBottomViewContrainerDelegate>

//will set it's dragDelegate to self & do other magical stuff
@property (nonatomic, weak) SBBottomViewContrainer *bottomContainerView;

- (void)rotateToHidden:(BOOL)isHidden;

@end
