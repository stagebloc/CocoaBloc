//
//  SBDraggableView.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/2/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBDraggableView.h"

@interface SBDraggableView ()

@property (nonatomic, strong) NSDate *touchBeganTime;
@property (nonatomic) CGPoint touchBeganLocation;


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
    
    if ([self.dragDelegate respondsToSelector:@selector(draggableViewDidMove:)])
        [self.dragDelegate draggableViewDidMove:self];
    
    [super setFrame:frame];
}

#pragma mark - Touch methods
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if (![self doesAllowMovement])
        return;
    
    [self setScrollViewEnabled:NO];
    
    self.touchBeganLocation = [[touches anyObject] locationInView:self];
    self.touchBeganTime = [NSDate date];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (![self doesAllowMovement])
        return;
    
    [self setScrollViewEnabled:NO];
    
    CGPoint location = [[touches anyObject] locationInView:self.superview];
    CGRect frame = self.frame;
    if ([self canMoveInDirection:SBDraggableViewDirectionLeftRight])
        frame.origin.x = location.x - self.touchBeganLocation.x;
    if ([self canMoveInDirection:SBDraggableViewDirectionUpDown])
        frame.origin.y = location.y - self.touchBeganLocation.y;
    self.frame = frame;
}

- (void) touchesEndedOrCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setScrollViewEnabled:YES];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    [self touchesEndedOrCancelled:touches withEvent:event];
    if ([self.dragDelegate respondsToSelector:@selector(draggableViewDidStopMoving:)])
        [self.dragDelegate draggableViewDidStopMoving:self];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self touchesEndedOrCancelled:touches withEvent:event];
    
    NSTimeInterval timeSinceFirstTouch = [[NSDate date] timeIntervalSinceDate:self.touchBeganTime];
    if (timeSinceFirstTouch < .125f) {
        //This was a tap, call delegate method
        if ([self.dragDelegate respondsToSelector:@selector(draggableViewTapped:event:)])
            [self.dragDelegate draggableViewTapped:self event:event];
    }
    
    if ([self.dragDelegate respondsToSelector:@selector(draggableViewDidStopMoving:)])
        [self.dragDelegate draggableViewDidStopMoving:self];
}

@end
