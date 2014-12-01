//
//  SBReviewView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

typedef NS_ENUM(NSUInteger, SBTextFieldLayout) {
    SBTextFieldLayoutHidden = 0,
    SBTextFieldLayoutTitle,
    SBTextFieldLayoutTitleDescription
};

@interface SBReviewView : UIView

@property (strong, nonatomic) UIButton *rejectButton;
@property (strong, nonatomic) UIButton *acceptButton;
@property (strong, nonatomic) NSArray *bottomButtonConstraints;

@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *undoButton;

@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextField *descriptionField;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) NSArray *toolbarConstraints;

@property (nonatomic, assign) SBTextFieldLayout currentLayout;

- (RACSignal*) tapSignal;

@end
