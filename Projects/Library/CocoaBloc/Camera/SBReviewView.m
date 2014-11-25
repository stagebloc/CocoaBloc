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

static NSTimeInterval const kAnimationDuration = 0.35f;
static CGFloat const kAnimationDamping = 0.8f;
static CGFloat const kAnimationVelocity = 0.5f;

@interface SBReviewView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SBReviewView

#pragma mark - Getters/Setters
- (UIButton*) rejectButton {
    if (!_rejectButton) {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setImage:[UIImage imageNamed:@"close_circle"] forState:UIControlStateNormal];
        _rejectButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _rejectButton;
}

- (UIButton*) acceptButton {
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptButton setImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
        _acceptButton.imageView.contentMode = UIViewContentModeCenter;
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

- (UIToolbar*) toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), 0.f)];
        _toolBar.barStyle = UIBarStyleBlackOpaque;
    }
    return _toolBar;
}

- (UITextField*)titleField {
    if (!_titleField) {
        _titleField = [UITextField new];
        _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        [[UITextField appearance] setTintColor:[UIColor whiteColor]];
        _titleField.textColor = [UIColor whiteColor];
        _titleField.textAlignment = NSTextAlignmentCenter;
        _titleField.hidden = YES;
        _titleField.delegate = self;
        _titleField.tag = 0;
    }
    return _titleField;
}

- (UITextField*)descriptionField {
    if (!_descriptionField) {
        _descriptionField = [UITextField new];
        _descriptionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        [[UITextField appearance] setTintColor:[UIColor whiteColor]];
        _descriptionField.textColor = [UIColor whiteColor];
        _descriptionField.textAlignment = NSTextAlignmentCenter;
        _descriptionField.hidden = YES;
        _descriptionField.delegate = self;
        _descriptionField.tag = 1;
    }
    return _descriptionField;
}

- (UIView*) line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor whiteColor];
        _line.alpha = .5f;
        _line.hidden = YES;
    }
    return _line;
}

#pragma mark - View State
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //toolbar
        [self addSubview:self.toolBar];
        [self.toolBar addSubview:self.titleField];
        [self.toolBar addSubview:self.descriptionField];
        [self.toolBar addSubview:self.line];
        [self adjustToolBarConstraints:SCTextFieldLayoutHidden];
        
        //buttons
        [self addSubview:self.acceptButton];
        [self addSubview:self.rejectButton];
        [self adjustBottomButtonConstraintsWithBottomOffset:-40];
        
        CGSize buttonSize = CGSizeMake(50, 50);
        CGPoint buttonOffset = CGPointMake(20, 20);
        [self addSubview:self.drawButton];
        [self.drawButton autoSetDimensionsToSize:buttonSize];
        [self.drawButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolBar withOffset:buttonOffset.y];
        [self.drawButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-buttonOffset.x];
        
        [self addSubview:self.undoButton];
        [self.undoButton autoSetDimensionsToSize:buttonSize];
        [self.undoButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolBar withOffset:buttonOffset.y];
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
            
            if (self.currentLayout == SCTextFieldLayoutHidden) {
                if (self.titleField.text.length > 0) {
                    self.currentLayout = SCTextFieldLayoutTitleDescription;
                } else {
                    self.currentLayout = SCTextFieldLayoutTitle;
                }
            } else {
                self.currentLayout = SCTextFieldLayoutHidden;
            }
        }];
        
        [[self.titleField.rac_textSignal skip:1] subscribeNext:^(NSString *text) {
            @strongify(self);
            if (text.length == 0) {
                self.currentLayout = SCTextFieldLayoutTitle;
                self.descriptionField.text = nil;
                self.descriptionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
            } else {
                self.currentLayout = SCTextFieldLayoutTitleDescription;
            }
        }];
        
        [[[self.titleField rac_signalForControlEvents:UIControlEventEditingDidEndOnExit | UIControlEventEditingDidEnd] map:^NSNumber*(UITextField *field) {
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
- (void) setCurrentLayout:(SCTextFieldLayout)currentLayout {
    [self willChangeValueForKey:@"currentLayout"];
    _currentLayout = currentLayout;
    [self didChangeValueForKey:@"currentLayout"];
    [self adjustToolBarConstraints:currentLayout];
    [self animateLayoutChange];
}

- (void) adjustToolBarConstraints:(SCTextFieldLayout)layoutType {
    [self.toolbarConstraints autoRemoveConstraints];
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    CGFloat height = 105;
    CGFloat offset = height - 100;
    CGFloat titleOffset = offset;
    self.descriptionField.hidden = NO;
    self.titleField.hidden = NO;
    self.line.hidden = NO;
    switch (layoutType) {
        case SCTextFieldLayoutTitle:
            height = 50 + offset;
            self.descriptionField.hidden = YES;
            self.line.hidden = YES;
            break;
        case SCTextFieldLayoutTitleDescription:
            break;
        default: //hidden
            offset = height;
            titleOffset = 50;
            self.descriptionField.hidden = YES;
            self.titleField.hidden = YES;
            self.line.hidden = YES;
            break;
    }
    
    [constraints addObject:[self.toolBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self]];
    [constraints addObject:[self.toolBar autoSetDimension:ALDimensionHeight toSize:height]];
    [constraints addObject:[self.toolBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:-offset]]; //hidden
    
    [constraints addObject:[self.titleField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.toolBar]];
    [constraints addObject:[self.titleField autoSetDimension:ALDimensionHeight toSize:50]];
    [constraints addObject:[self.titleField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.toolBar withOffset:titleOffset]];
    
    [constraints addObject:[self.descriptionField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.toolBar]];
    [constraints addObject:[self.descriptionField autoSetDimension:ALDimensionHeight toSize:50]];
    [constraints addObject:[self.descriptionField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.toolBar]];
    
    [constraints addObject:[self.line autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.toolBar]];
    [constraints addObject:[self.line autoSetDimension:ALDimensionHeight toSize:1]];
    [constraints addObject:[self.line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleField]];
    
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

#pragma mark - Textfield Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField; {
    if ([textField.text length] == 0) {
        if (textField.tag == 0) {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];;
        } else {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
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
