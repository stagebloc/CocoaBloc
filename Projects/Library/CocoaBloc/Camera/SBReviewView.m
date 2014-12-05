//
//  SBReviewView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 11/24/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBReviewView.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIView+Extension.h"

static NSTimeInterval const kAnimationDuration = 0.35f;
static CGFloat const kAnimationDamping = 1.0f;
static CGFloat const kAnimationVelocity = 0.5f;

@interface SBReviewView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SBReviewView

#pragma mark - Getters/Setters
- (UIButton*) rejectButton {
    if (!_rejectButton) {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setImage:[[UIImage imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _rejectButton.tintColor = [UIColor colorWithRed:1 green:.294117647 blue:.376470588 alpha:1];
        _rejectButton.imageView.contentMode = UIViewContentModeCenter;
        _rejectButton.backgroundColor = [UIColor whiteColor];
    }
    return _rejectButton;
}

- (UIButton*) acceptButton {
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptButton setImage:[[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _acceptButton.tintColor = [UIColor colorWithRed:.078431373 green:.866666667 blue:.807843137 alpha:1];
        _acceptButton.imageView.contentMode = UIViewContentModeCenter;
        _acceptButton.backgroundColor = [UIColor whiteColor];
    }
    return _acceptButton;
}

- (UIButton*) undoButton {
    if (!_undoButton) {
        _undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_undoButton setImage:[UIImage imageNamed:@"undo_circle"] forState:UIControlStateNormal];
        _undoButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _undoButton;
}

- (UIButton*) drawButton {
    if (!_drawButton) {
        _drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_drawButton setImage:[UIImage imageNamed:@"draw_circle"] forState:UIControlStateNormal];
        _drawButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _drawButton;
}

- (UIView*) textContainerView {
    if (!_textContainerView) {
        _textContainerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), 0.f)];
    }
    return _textContainerView;
}

- (UIToolbar*) toolBarTitleField {
    if (!_toolBarTitleField) {
        _toolBarTitleField = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), 50)];
        _toolBarTitleField.barStyle = UIBarStyleBlack;
        _toolBarTitleField.translucent = YES;
    }
    return _toolBarTitleField;
}

- (UITextField*)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 50)];
        _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"title" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        [[UITextField appearance] setTintColor:[UIColor whiteColor]];
        _titleField.textColor = [UIColor whiteColor];
        _titleField.textAlignment = NSTextAlignmentCenter;
    }
    return _titleField;
}

- (UIToolbar*) toolBarDescriptionField {
    if (!_toolBarDescriptionField) {
        _toolBarDescriptionField = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), 50)];
        _toolBarDescriptionField.barStyle = UIBarStyleBlack;
        _toolBarDescriptionField.translucent = YES;
    }
    return _toolBarDescriptionField;
}

- (UITextField*)descriptionField {
    if (!_descriptionField) {
        _descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 50)];
        _descriptionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"caption" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        [[UITextField appearance] setTintColor:[UIColor whiteColor]];
        _descriptionField.textColor = [UIColor whiteColor];
        _descriptionField.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionField;
}

#pragma mark - View State
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //toolbar
        [self addSubview:self.textContainerView];
        [self.textContainerView addSubview:self.toolBarTitleField];
        [self.textContainerView addSubview:self.toolBarDescriptionField];
        
        [self.toolBarTitleField addSubview:self.titleField];
        [self.titleField autoCenterInSuperviewWithMatchedDimensions];
        
        [self.toolBarDescriptionField addSubview:self.descriptionField];
        [self.descriptionField autoCenterInSuperviewWithMatchedDimensions];

        [self adjustToolBarConstraints:SBTextFieldLayoutHidden];
        
        //buttons
        [self addSubview:self.acceptButton];
        [self addSubview:self.rejectButton];
        [self adjustBottomButtonConstraintsWithBottomOffset:-40];
        
        CGSize buttonSize = CGSizeMake(50, 50);
        CGPoint buttonOffset = CGPointMake(20, 20);
        [self addSubview:self.drawButton];
        [self.drawButton autoSetDimensionsToSize:buttonSize];
        [self.drawButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textContainerView withOffset:buttonOffset.y];
        [self.drawButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-buttonOffset.x];
        
        [self addSubview:self.undoButton];
        [self.undoButton autoSetDimensionsToSize:buttonSize];
        [self.undoButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textContainerView withOffset:buttonOffset.y];
        [self.undoButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:buttonOffset.x];
        
        //notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        @weakify(self)
        
        //gestures
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        [[self.tapGesture rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *gesture) {
            @strongify(self);
            
            if (self.descriptionField.isEditing || self.titleField.isEditing) {
                [self endEditing:YES];
                return;
            }
            
            if (self.currentLayout == SBTextFieldLayoutHidden) {
                if (self.titleField.text.length > 0) {
                    self.currentLayout = SBTextFieldLayoutTitleDescription;
                } else {
                    self.currentLayout = SBTextFieldLayoutTitle;
                }
            }
//            else {
//                self.currentLayout = SBTextFieldLayoutHidden;
//            }
            else if (self.currentLayout == SBTextFieldLayoutTitle && self.titleField.text.length == 0){
                self.currentLayout = SBTextFieldLayoutHidden;
            }
        }];
        
        [[self.titleField.rac_textSignal skip:1] subscribeNext:^(NSString *text) {
            @strongify(self);
            if (text.length == 0) {
                self.currentLayout = SBTextFieldLayoutTitle;
            } else {
                self.currentLayout = SBTextFieldLayoutTitleDescription;
            }
        }];
        
        [[[self.titleField rac_signalForControlEvents:UIControlEventEditingDidEndOnExit] map:^NSNumber*(UITextField *field) {
            return @(field.text.length > 0);
        }] subscribeNext:^(NSNumber *isTextEntered) {
            @strongify(self);
            if (isTextEntered.boolValue) {
                [self.descriptionField becomeFirstResponder];
            }
        }];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout
- (void) layoutSubviews {
    [super layoutSubviews];
    _acceptButton.layer.cornerRadius = CGRectGetHeight(_acceptButton.frame) / 2;
    _rejectButton.layer.cornerRadius = CGRectGetHeight(_rejectButton.frame) / 2;
}

- (void) setCurrentLayout:(SBTextFieldLayout)currentLayout {
    [self willChangeValueForKey:@"currentLayout"];
    _currentLayout = currentLayout;
    [self didChangeValueForKey:@"currentLayout"];
    [self adjustToolBarConstraints:currentLayout];
    [self animateLayoutChange];
}

- (void) adjustToolBarConstraints:(SBTextFieldLayout)layoutType {
    [self.toolbarConstraints autoRemoveConstraints];
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    CGFloat height = 105;
    CGFloat offset = height - 100;
    CGFloat titleOffset = offset;
    self.toolBarDescriptionField.hidden = NO;
    self.toolBarTitleField.hidden = NO;
    switch (layoutType) {
        case SBTextFieldLayoutTitle:
            height = 50 + offset;
            self.toolBarDescriptionField.hidden = YES;
            break;
        case SBTextFieldLayoutTitleDescription:
            break;
        default: //hidden
            offset = height;
            titleOffset = 50;
            self.toolBarDescriptionField.hidden = YES;
            self.toolBarTitleField.hidden = YES;
            break;
    }
    
    [constraints addObject:[self.textContainerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self]];
    [constraints addObject:[self.textContainerView autoSetDimension:ALDimensionHeight toSize:height]];
    [constraints addObject:[self.textContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:-offset]]; //hidden
    
    [constraints addObject:[self.toolBarTitleField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.textContainerView]];
    [constraints addObject:[self.toolBarTitleField autoSetDimension:ALDimensionHeight toSize:50]];
    [constraints addObject:[self.toolBarTitleField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.textContainerView withOffset:titleOffset]];
    
    [constraints addObject:[self.toolBarDescriptionField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.textContainerView]];
    [constraints addObject:[self.toolBarDescriptionField autoSetDimension:ALDimensionHeight toSize:50]];
    [constraints addObject:[self.toolBarDescriptionField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.textContainerView]];
        
    self.toolbarConstraints = [constraints copy];
}

- (void) adjustBottomButtonConstraintsWithBottomOffset:(CGFloat)bottomOffset {
    [self.bottomButtonConstraints autoRemoveConstraints];
    NSMutableArray *constraints = [NSMutableArray array];
    
    CGPoint buttonOffset = CGPointMake(40, bottomOffset);
    CGSize buttonSize = CGSizeMake(60, 60);
    
    [constraints addObjectsFromArray:[self.acceptButton autoSetDimensionsToSize:buttonSize]];
    [constraints addObject:[self.acceptButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:buttonOffset.y]];
    [constraints addObject:[self.acceptButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-buttonOffset.x]];
    
    [constraints addObjectsFromArray:[self.rejectButton autoSetDimensionsToSize:buttonSize]];
    [constraints addObject:[self.rejectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:buttonOffset.y]];
    [constraints addObject:[self.rejectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:buttonOffset.x]];
    
    self.bottomButtonConstraints = [constraints copy];
}

#pragma mark - Signals
- (RACSignal*) tapSignal {
    return self.tapGesture.rac_gestureSignal;
}

#pragma mark - Animations
- (void) animateLayoutChange {
    [self animateLayoutChangeWithDuration:kAnimationDuration damping:kAnimationDamping velocity:kAnimationVelocity];
}

- (void) animateLayoutChangeWithDuration:(NSTimeInterval)duration damping:(CGFloat)damping velocity:(CGFloat)velocity{
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:0 animations:^{
        [self layoutSubviews];
    } completion:nil];
}

#pragma mark - Button animation methods

- (void)keyboardWillShow:(NSNotification*)notification {
    [self adjustButtonsForKeyboardNotification:notification isHiding:NO];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self adjustButtonsForKeyboardNotification:notification isHiding:YES];
}

- (void)adjustButtonsForKeyboardNotification:(NSNotification *)notification isHiding:(BOOL)isHiding{
    NSDictionary *notificationInfo = [notification userInfo];
    CGRect finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    finalKeyboardFrame = [self convertRect:finalKeyboardFrame fromView:self.window];
    if (isHiding) [self adjustBottomButtonConstraintsWithBottomOffset:-40];
    else [self adjustBottomButtonConstraintsWithBottomOffset:-finalKeyboardFrame.size.height - 20];
    [self animateLayoutChangeWithDuration:animationDuration damping:.95 velocity:.5];
}

@end
