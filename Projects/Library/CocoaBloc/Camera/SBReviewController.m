//
//  SCReviewControllers.m
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBReviewController.h"
#import <PureLayout/PureLayout.h>
#import "SBAssetsManager.h"
#import "SBCaptureManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

typedef NS_ENUM(NSUInteger, SCTextFieldLayout) {
    SCTextFieldLayoutHidden = 0,
    SCTextFieldLayoutTitle,
    SCTextFieldLayoutTitleDescription
};

static NSTimeInterval const kAnimationDuration = 0.35f;
static CGFloat const kAnimationDamping = 0.8f;
static CGFloat const kAnimationVelocity = 0.5f;

@interface SBReviewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) ALAsset *asset;

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

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;


@property (nonatomic, assign) SCTextFieldLayout currentLayout;

@end

@implementation SBReviewController

#pragma mark - Getters/Setters
- (UIButton*) rejectButton {
    if (!_rejectButton) {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setImage:[UIImage imageNamed:@"close_circle"] forState:UIControlStateNormal];
        _rejectButton.imageView.contentMode = UIViewContentModeCenter;
        [_rejectButton addTarget:self action:@selector(rejectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectButton;
}

- (UIButton*) acceptButton {
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptButton setImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
        _acceptButton.imageView.contentMode = UIViewContentModeCenter;
        [_acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptButton;
}

- (UIButton*) undoButton {
    if (!_undoButton) {
        _undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_undoButton setImage:[UIImage imageNamed:@"undo_circle"] forState:UIControlStateNormal];
        _undoButton.imageView.contentMode = UIViewContentModeCenter;
        [_undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoButton;
}

- (UIButton*) drawButton {
    if (!_drawButton) {
        _drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_drawButton setImage:[UIImage imageNamed:@"draw_circle"] forState:UIControlStateNormal];
        _drawButton.imageView.contentMode = UIViewContentModeCenter;
        [_drawButton addTarget:self action:@selector(drawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drawButton;
}

- (UIToolbar*) toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), 0.f)];
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

- (void) setCurrentLayout:(SCTextFieldLayout)currentLayout {
    [self willChangeValueForKey:@"currentLayout"];
    _currentLayout = currentLayout;
    [self didChangeValueForKey:@"currentLayout"];
    [self adjustToolBarConstraints:currentLayout];
    [self animateLayoutChange];
}

#pragma mark - Init methods
- (instancetype) initWithImage:(UIImage*)image {
    if (self = [super init]){
        self.image = image;
    }
    return self;
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
    
    [constraints addObject:[self.toolBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view]];
    [constraints addObject:[self.toolBar autoSetDimension:ALDimensionHeight toSize:height]];
    [constraints addObject:[self.toolBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:-offset]]; //hidden
    
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
    [constraints addObject:[self.acceptButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:buttonOffset.y]];
    [constraints addObject:[self.acceptButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-buttonOffset.x]];
    
    [constraints addObjectsFromArray:[self.rejectButton autoSetDimensionsToSize:buttonSize]];
    [constraints addObject:[self.rejectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:buttonOffset.y]];
    [constraints addObject:[self.rejectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:buttonOffset.x]];
    
    self.bottomButtonConstraints = [constraints copy];
}

#pragma mark - View State
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.view.backgroundColor = [UIColor blackColor];
    
    //image view
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Screen aspect ratio / image aspect ratio x screen width -> fit image height to screen and set scrollview content width
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView autoCenterInSuperview];
    [self.scrollView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
    [self.scrollView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    
    [self.scrollView addSubview:self.imageView];
    [self.imageView autoCenterInSuperview];
    [self.imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
    [self.imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
    
    //toolbar
    [self.view addSubview:self.toolBar];
    [self.toolBar addSubview:self.titleField];
    [self.toolBar addSubview:self.descriptionField];
    [self.toolBar addSubview:self.line];
    [self adjustToolBarConstraints:SCTextFieldLayoutHidden];
    
    //buttons
    [self.view addSubview:self.acceptButton];
    [self.view addSubview:self.rejectButton];
    [self adjustBottomButtonConstraintsWithBottomOffset:-40];

    CGSize buttonSize = CGSizeMake(50, 50);
    CGPoint buttonOffset = CGPointMake(20, 20);
    [self.view addSubview:self.drawButton];
    [self.drawButton autoSetDimensionsToSize:buttonSize];
    [self.drawButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolBar withOffset:buttonOffset.y];
    [self.drawButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-buttonOffset.x];

    [self.view addSubview:self.undoButton];
    [self.undoButton autoSetDimensionsToSize:buttonSize];
    [self.undoButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolBar withOffset:buttonOffset.y];
    [self.undoButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:buttonOffset.x];

    //gestures
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];

    //notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    @weakify(self)
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
}

#pragma mark - Textfield Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField;
{
    if ([textField.text length] == 0) {
        if (textField.tag == 0) {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];;
        } else {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Tap gesture
-(void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    //just end editing and keep current state
    if (self.descriptionField.isEditing || self.titleField.isEditing) {
        [self.view endEditing:YES];
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
}

#pragma mark - Animations
- (void) animateLayoutChange {
    [self animateLayoutChangeWithDuration:kAnimationDuration damping:kAnimationDamping velocity:kAnimationVelocity];
}

- (void) animateLayoutChangeWithDuration:(NSTimeInterval)duration damping:(CGFloat)damping velocity:(CGFloat)velocity{
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:0 animations:^{
        [self.view layoutSubviews];
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
    UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    finalKeyboardFrame = [self.view convertRect:finalKeyboardFrame fromView:self.view.window];
    if (isHiding) [self adjustBottomButtonConstraintsWithBottomOffset:-40];
    else [self adjustBottomButtonConstraintsWithBottomOffset:-finalKeyboardFrame.size.height - 20];
    [self animateLayoutChangeWithDuration:animationDuration damping:.95 velocity:.5];
}

#pragma mark Actions

- (void) undoButtonPressed:(UIButton*)button {
    
}

- (void) drawButtonPressed:(UIButton*)button {
    
}

-(void)rejectButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reviewController:rejectedImage:)]) {
        [self.delegate reviewController:self rejectedImage:self.image];
    }
}

-(void)acceptButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reviewController:acceptedImage:title:description:)]) {
        [self.delegate reviewController:self acceptedImage:self.image title:self.titleField.text description:self.descriptionField.text];
    }
}

#pragma mark - Status bar states
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
