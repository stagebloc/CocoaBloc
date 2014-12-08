//
//  SBFadeLabel.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SBFadeLabelType) {
    SBFadeLabelTypeFadeNone = 0,
    SBFadeLabelTypeFadeLeft,
    SBFadeLabelTypeFadeRight,
    SBFadeLabelTypeFadeAll,
};

@interface SBFadeLabel : UILabel

@property (nonatomic, assign) NSInteger maxCharsShown;

@property (nonatomic, assign) SBFadeLabelType type;

- (void) setType:(SBFadeLabelType)type toAlpha:(CGFloat)toAlpha duration:(NSTimeInterval)duration;

- (instancetype) initWithAttributedText:(NSAttributedString*)attributedString;

@end
