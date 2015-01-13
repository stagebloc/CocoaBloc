//
//  SBDraggableView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBDraggableView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SBDraggableView () <UIGestureRecognizerDelegate>

@property (nonatomic) NSDate *panStarted;

@end

@implementation SBDraggableView

- (BOOL) canMoveInDirection:(SBDraggableViewDirection)direction {
    return (self.dragDirection  & direction) != 0;
}

- (BOOL) doesAllowMovement {
    return (self.dragDirection & SBDraggableViewDirectionNone) == 0;
}

- (void) setScrollViewEnabled:(BOOL)isEnabled {
    if ([self.superview isKindOfClass:[UIScrollView class]])
        ((UIScrollView*)self.superview).scrollEnabled = isEnabled;
}

- (void) setFrame:(CGRect)frame {
    if (self.leftRestriction && frame.origin.x <= self.leftRestriction.floatValue)
        frame.origin.x = self.leftRestriction.floatValue;
    else if (self.rightRestriction && frame.origin.x + frame.size.width >= self.rightRestriction.floatValue)
        frame.origin.x = self.rightRestriction.floatValue - frame.size.width;
    
    if (self.topRestriction && frame.origin.y <= self.topRestriction.floatValue)
        frame.origin.y = self.topRestriction.floatValue;
    else if (self.bottomRestriction && frame.origin.y + frame.size.height >= self.bottomRestriction.floatValue)
        frame.origin.y = self.bottomRestriction.floatValue - frame.size.height;
    
    
    [self moved];
    if ([self.dragDelegate respondsToSelector:@selector(draggableViewDidMove:)])
        [self.dragDelegate draggableViewDidMove:self];
    
    
    [super setFrame:frame];
}

- (void) initDefaults {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

- (instancetype) init {
    if (self = [super init]) {
        [self initDefaults];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaults];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaults];
    }
    return self;
}

#pragma mark - Gestures
- (void) panGesture:(UIPanGestureRecognizer*)gesture {
    UIView *view = gesture.view;
    CGPoint translation = [gesture translationInView:view];
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect frame = view.frame;
    if ([self canMoveInDirection:SBDraggableViewDirectionLeftRight])
        frame.origin.x += translation.x;
    if ([self canMoveInDirection:SBDraggableViewDirectionUpDown])
        frame.origin.y += translation.y;
    view.frame = frame;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [gesture setTranslation:CGPointMake(0, 0) inView:view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.panStarted = [NSDate date];
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        if ([self.dragDelegate respondsToSelector:@selector(draggableViewDidMove:)]) {
            [self.dragDelegate draggableViewDidMove:self];
        }
        [self moved];
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled ||
             gesture.state == UIGestureRecognizerStateFailed) {
        
        CGPoint velGest = [gesture velocityInView:view];
        CGPoint origin = frame.origin;
        CGPoint velocity = CGPointMake(origin.x == 0 ? 0 : velGest.x / frame.origin.x , origin.y == 0 ? 0 : velGest.y / frame.origin.y) ;
        if ([self.dragDelegate respondsToSelector:@selector(draggableViewDidStopMoving:velocity:)]) {
            [self.dragDelegate draggableViewDidStopMoving:self velocity:velocity];
        }
        [self stoppedMovingWithVelocity:velocity];
        
        self.panStarted = nil;
    }
    
}

// gesture recognizer should only begin when horizontally panning
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    if (fabs(velocity.x) > fabs(velocity.y) && [self canMoveInDirection:SBDraggableViewDirectionLeftRight])
        return YES;
    if (fabs(velocity.y) > fabs(velocity.x) && [self canMoveInDirection:SBDraggableViewDirectionUpDown])
        return YES;
    if ([self canMoveInDirection:SBDraggableViewDirectionLeftRight] || [self canMoveInDirection:SBDraggableViewDirectionUpDown])
        return YES;
    return NO;
}

@end

@implementation SBDraggableView (Subclassing)

- (void) moved {
    
}

- (void) stoppedMovingWithVelocity:(CGPoint)velocity {
    
}

@end
