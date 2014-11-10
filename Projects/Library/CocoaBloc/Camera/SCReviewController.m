//
//  SCReviewControllers.m
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SCReviewController.h"
#import <PureLayout/PureLayout.h>
#import "SCAssetsManager.h"
#import "SCCaptureManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCReviewController () <SCPhotoManagerDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIButton *rejectButton;
@property (strong, nonatomic) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *undoButton;

@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextField *descriptionField;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation SCReviewController

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

- (instancetype) initWithImage:(UIImage*)image {
    if (self = [super init]){
        self.image = image;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    CGPoint buttonOffset = CGPointMake(40, 40);

    CGSize buttonSize = CGSizeMake(60, 60);
    [self.view addSubview:self.acceptButton];
    [self.acceptButton autoSetDimensionsToSize:buttonSize];
    [self.acceptButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-buttonOffset.y];
    [self.acceptButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-buttonOffset.x];

    [self.view addSubview:self.rejectButton];
    [self.rejectButton autoSetDimensionsToSize:buttonSize];
    [self.rejectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-buttonOffset.y];
    [self.rejectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:buttonOffset.x];

    buttonSize = CGSizeMake(50, 50);
    buttonOffset = CGPointMake(20, 100);
    [self.view addSubview:self.drawButton];
    [self.drawButton autoSetDimensionsToSize:buttonSize];
    [self.drawButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:buttonOffset.y];
    [self.drawButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-buttonOffset.x];

    [self.view addSubview:self.undoButton];
    [self.undoButton autoSetDimensionsToSize:buttonSize];
    [self.undoButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:buttonOffset.y];
    [self.undoButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:buttonOffset.x];

    
    if (_image.size.width == _image.size.height) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
        imageView.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds) , CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
        [self.view addSubview:imageView];

    } else {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        // Screen aspect ratio / image aspect ratio x screen width -> fit image height to screen and set scrollview content width
        CGFloat contentWidth = (CGRectGetHeight(self.view.bounds)/CGRectGetWidth(self.view.bounds) / (_image.size.height/_image.size.width)) * CGRectGetWidth(self.view.bounds);
        _scrollView.contentSize = CGSizeMake(contentWidth, _scrollView.frame.size.height);
        CGFloat xOffset = ((contentWidth - CGRectGetWidth(self.view.bounds))/2);
        [_scrollView setContentOffset:CGPointMake(xOffset, _scrollView.frame.origin.y)];
        [self.view insertSubview:_scrollView belowSubview:self.rejectButton];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
        imageView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, contentWidth, _scrollView.frame.size. height);
        [_scrollView addSubview:imageView];
    }

    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), 0.f)];
    _toolBar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_toolBar];

    _titleField = [UITextField new];
    _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    _titleField.textColor = [UIColor whiteColor];
    _titleField.textAlignment = NSTextAlignmentCenter;
    _titleField.hidden = YES;
    _titleField.delegate = self;
    _titleField.tag = 0;
    [_toolBar addSubview:_titleField];

    _descriptionField = [UITextField new];
    _descriptionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    _descriptionField.textColor = [UIColor whiteColor];
    _descriptionField.textAlignment = NSTextAlignmentCenter;
    _descriptionField.hidden = YES;
    _descriptionField.delegate = self;
    _descriptionField.tag = 1;
    [_toolBar addSubview:_descriptionField];

    _line = [UIView new];
    _line.backgroundColor = [UIColor whiteColor];
    _line.alpha = .5f;
    _line.hidden = YES;
    [_toolBar addSubview:_line];

    [[_titleField.rac_textSignal skip:1] subscribeNext:^(NSString *text) {
        if (text.length < 1) {
            [self animateDescriptionUp];
            _descriptionField.text = nil;
            _descriptionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        } else {
            [self animateDescriptionDown];
        }
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Status bar states
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Textfield Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField;
{
    if ([textField.text length] == 0) {
        if (textField.tag == 0) {
            _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];;
        } else {
            _descriptionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f]}];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Tap gesture

-(void)handleTap:(UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
    if (_descriptionField.text.length > 0) {
        [self animateDescriptionDown];
    } else {
        [self animateTitleDown];
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)panRecognizer
{
    static CGPoint startLocation;
    CGPoint touchLocation = [panRecognizer locationInView:self.view];

    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        startLocation = [panRecognizer locationInView:self.view];
    }

    if (startLocation.y - touchLocation.y > 50.f) {
        [self animateTitleUp];
    }

    if (startLocation.y - touchLocation.y < 50.f) {
        if (_descriptionField.text.length > 0) {
            [self animateDescriptionDown];
        } else {
            [self animateTitleDown];
        }
        [self.view endEditing:YES];
    }
}

-(void)animateTitleUp
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _line.hidden = YES;
                         _descriptionField.hidden = YES;
                         _titleField.hidden = YES;
                         _toolBar.frame = CGRectMake(_toolBar.frame.origin.x, _toolBar.frame.origin.y, _toolBar.frame.size.width, 0.f);
                     }
                     completion:nil];
}

-(void)animateTitleDown
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _line.hidden = YES;
                         _descriptionField.hidden = YES;
                         _toolBar.frame = CGRectMake(_toolBar.frame.origin.x, _toolBar.frame.origin.y, _toolBar.frame.size.width, 50.f);
                         _titleField.frame = _toolBar.bounds;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             _titleField.hidden = NO;
                         }
                     }];
}

-(void)animateDescriptionUp
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _line.hidden = YES;
                         _descriptionField.hidden = YES;
                         _titleField.hidden = NO;
                         _toolBar.frame = CGRectMake(_toolBar.frame.origin.x, _toolBar.frame.origin.y, _toolBar.frame.size.width, 50.f);
                     }
                     completion:nil];
}

-(void)animateDescriptionDown
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _toolBar.frame = CGRectMake(_toolBar.frame.origin.x, _toolBar.frame.origin.y, _toolBar.frame.size.width, 100.f);
                         _titleField.frame = CGRectMake(CGRectGetMinX(_toolBar.bounds), CGRectGetMinY(_toolBar.bounds), CGRectGetWidth(_toolBar.bounds), 50.f);
                         _descriptionField.frame = CGRectMake(CGRectGetMinX(_toolBar.bounds), CGRectGetMaxY(_titleField.bounds), CGRectGetWidth(_toolBar.bounds), 50.f);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             _line.frame = CGRectMake(CGRectGetMinX(_titleField.bounds), CGRectGetMaxY(_titleField.bounds), CGRectGetWidth(_titleField.bounds), 1.0f);
                             _line.hidden = NO;
                             _descriptionField.hidden = NO;
                             _titleField.hidden = NO;
                         }
                    }];
}

#pragma mark - Button animation methods

- (void)keyboardWillShow:(NSNotification*)notification {
    [self adjustButtonsForKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self adjustButtonsForKeyboardNotification:notification];
}

- (void)adjustButtonsForKeyboardNotification:(NSNotification *)notification {
    NSDictionary *notificationInfo = [notification userInfo];
    CGRect finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    finalKeyboardFrame = [self.view convertRect:finalKeyboardFrame fromView:self.view.window];
    CGRect rejectButtonFrame = _rejectButton.frame;
    rejectButtonFrame.origin.y = finalKeyboardFrame.origin.y - rejectButtonFrame.size.height - 25.f;
    CGRect acceptButtonFrame = _acceptButton.frame;
    acceptButtonFrame.origin.y = finalKeyboardFrame.origin.y - acceptButtonFrame.size.height - 25.f;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];

    _acceptButton.frame = acceptButtonFrame;
    _rejectButton.frame = rejectButtonFrame;
    
    [UIView commitAnimations];
}

#pragma mark Actions

- (void) undoButtonPressed:(UIButton*)button {
    
}

- (void) drawButtonPressed:(UIButton*)button {
    
}

-(void)rejectButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(reviewController:rejectedImage:)])
        [self.delegate reviewController:self rejectedImage:self.image];
    [[SCCaptureManager sharedInstance] photoManager].image = nil;
}

-(void)acceptButtonPressed:(id)sender {
//    NSDictionary *info = @{@"title" : _titleField.text, @"description" : _descriptionField.text};
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
//    [UIImagePNGRepresentation(_image) writeToFile:filePath atomically:YES];
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved to Device" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
    if ([self.delegate respondsToSelector:@selector(reviewController:acceptedImage:)])
        [self.delegate reviewController:self acceptedImage:self.image];
}


@end
