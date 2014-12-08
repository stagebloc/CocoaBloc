//
//  SBFadeLabel.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBFadeLabel.h"
#import "NSMutableAttributedString+Extensions.h"

@implementation SBFadeLabel

- (CGFloat) alphaForCharPosition:(int)pos reverse:(BOOL)isReversed{
    CGFloat toReturn = 0;
    int const Max = self.maxCharsShown;
    CGFloat const MaxDiv = Max+2;
    if (pos <= Max)
        toReturn = (pos / (MaxDiv));
    
    if (isReversed) {
        CGFloat const Reverse = Max / MaxDiv;
        toReturn = Reverse - toReturn;
    }
    
    return toReturn;
}

- (void) setType:(SBFadeLabelType)type {
    [self setType:type duration:0];
}

- (void) setType:(SBFadeLabelType)type duration:(NSTimeInterval)duration {
    [self willChangeValueForKey:@"type"];
    _type = type;
    [self didChangeValueForKey:@"type"];
    
    NSMutableAttributedString *attrString = [self.attributedText mutableCopy];
    [attrString removeAllAttributes];
    
    NSUInteger const len = self.attributedText.length;
    switch (type) {
        case SBFadeLabelTypeFadeLeft: {
            for (int i = 0; i < len; i++) {
                CGFloat alpha = [self alphaForCharPosition:i reverse:NO];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:alpha] range:NSMakeRange(i, 1)];
            }
            break;
        }
       
        case SBFadeLabelTypeFadeRight: {
            for (int i = 0; i < len; i++) {
                CGFloat alpha = [self alphaForCharPosition:i reverse:YES];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:alpha] range:NSMakeRange(i, 1)];
            }
            break;
        }
        
        case SBFadeLabelTypeFadeAll: {
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:0] range:NSMakeRange(0, len)];
            break;
        }
            
        default:
            [attrString removeAllAttributes];
            self.textColor = [UIColor whiteColor];
            break;
    }
    self.attributedText = attrString;
}

- (instancetype) initWithAttributedText:(NSAttributedString*)attributedString {
    if (self = [super init]) {
        self.maxCharsShown = 5;
        self.attributedText = attributedString;
        self.numberOfLines = 1;
        [self sizeToFit];
    }
    return self;
}

@end
