//
//  SBReviewView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBBottomViewContrainer.h"

@class RACSignal, SBCaptionButton, SBOptionsChevronButton;

typedef NS_ENUM(NSUInteger, SBTextFieldLayout) {
    SBTextFieldLayoutHidden = 0,
    SBTextFieldLayoutTitle,
    SBTextFieldLayoutTitleDescription
};

@interface SBReviewView : UIView <SBBottomViewContrainerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIButton *rejectButton;
@property (strong, nonatomic) UIButton *acceptButton;
@property (strong, nonatomic) NSArray *bottomButtonConstraints;

@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *undoButton;

@property (strong, nonatomic) UIView *textContainerView;
@property (strong, nonatomic) UIToolbar *toolBarTitleField;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UIToolbar *toolBarDescriptionField;
@property (strong, nonatomic) UITextField *descriptionField;
@property (strong, nonatomic) NSArray *toolbarConstraints;

@property (nonatomic, strong) SBOptionsChevronButton *optionsMenuButton;

@property (nonatomic, strong) SBBottomViewContrainer *optionsViewContainer;
@property (nonatomic, strong) SBCaptionButton *officialButton;
@property (nonatomic, strong) SBCaptionButton *exclusiveButton;

@property (nonatomic, assign) SBTextFieldLayout currentLayout;

- (RACSignal*) tapSignal;

@end
