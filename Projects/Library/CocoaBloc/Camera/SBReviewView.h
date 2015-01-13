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

typedef NS_OPTIONS(NSUInteger, SBReviewViewOptions) {
    SBReviewViewOptionsDoNotShow = 1 << 0,
    SBReviewViewOptionsShowOfficialButton = 1 << 1,
    SBReviewViewOptionsShowExclusiveButton = 1 << 2,
};

@interface SBReviewView : UIView <SBDraggableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) SBReviewViewOptions options;

@property (strong, nonatomic) UIButton *rejectButton;
@property (strong, nonatomic) UIButton *acceptButton;
@property (strong, nonatomic) NSArray *bottomButtonConstraints;

@property (nonatomic) UIButton *drawButton;
@property (nonatomic) UIButton *undoButton;

@property (strong, nonatomic) UIView *textContainerView;
@property (strong, nonatomic) UIToolbar *toolBarTitleField;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UIToolbar *toolBarDescriptionField;
@property (strong, nonatomic) UITextField *descriptionField;
@property (strong, nonatomic) NSArray *toolbarConstraints;

@property (nonatomic) SBOptionsChevronButton *optionsMenuButton;

@property (nonatomic) SBBottomViewContrainer *optionsViewContainer;
@property (nonatomic) SBCaptionButton *officialButton;
@property (nonatomic) SBCaptionButton *exclusiveButton;

@property (nonatomic, assign) SBTextFieldLayout currentLayout;

- (RACSignal*) tapSignal;

@end
