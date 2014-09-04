//
//  SBActionButton.m
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBActionButton.h"
#import "UIColor+FanClub.h"
#import "UIFont+FanClub.h"

@implementation SBActionButton

+ (instancetype)buttonWithActionType:(SBActionType)type {
    SBActionButton *ret = [SBActionButton new];
    ret.actionType = type;
    return ret;
}

- (id)init {
    if ((self = [super init])) {
        [self registerEventHandlers];
        [self applyAppearanceTraits];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self registerEventHandlers];
        [self applyAppearanceTraits];
    }
    return self;
}

- (void)applyAppearanceTraits {
    [self.titleLabel setFont:[UIFont fc_fontWithSize:12]];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

- (CGSize)intrinsicContentSize {
    CGSize orig = [super intrinsicContentSize];
    orig.width += 5;
    return orig;
}

- (void)registerEventHandlers {
    [self addTarget:self action:@selector(handleTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleTouchUpInside {
    BOOL shouldBeSelected = !self.selected;
    self.actionCount += shouldBeSelected ? self.actionCountSelectionIncrease : -self.actionCountSelectionIncrease;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    self.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.2 options:0 animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
        self.selected = shouldBeSelected;
    } completion:nil];
}

- (void)setActionType:(SBActionType)type {
    NSString *normalImageName = nil;
    NSString *selectedImageName = nil;
    
    switch (type) {
        case SBActionTypeLike:
            normalImageName = @"action_like";
            selectedImageName = @"action_like_active";
            self.actionCountSelectionIncrease = 1;
            [self setTitleColor:[UIColor fc_lightTextColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor fc_pinkColor] forState:UIControlStateSelected];
            
            break;
        case SBActionTypeComment:
            normalImageName = @"action_comment";
            self.actionCountSelectionIncrease = 0;
            
            break;
            
        default: [NSException raise:@"SBActionButtonException" format:@"Unsupported button type: %ld", type];
    }
    
    [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    
    if (selectedImageName) {
    	[self setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    } else {
        [self setImage:nil forState:UIControlStateSelected];
    }
}

- (void)setActionCount:(NSUInteger)actionCount {
    _actionCount = actionCount;
    
    if (!actionCount) {
        [self setTitle:nil forState:UIControlStateNormal];
    } else {
        [self setTitle:@(actionCount).stringValue forState:UIControlStateNormal];
        [self setTitle:@(actionCount).stringValue forState:UIControlStateSelected];
    }
    [self invalidateIntrinsicContentSize];
}

@end
