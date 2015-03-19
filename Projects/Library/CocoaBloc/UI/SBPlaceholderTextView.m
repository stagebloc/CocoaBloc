//
// Created by John Heaton on 2/4/15.
// Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBPlaceholderTextView.h"


@implementation SBPlaceholderTextView

#pragma mark - Overrides

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textChangedNotification:(NSNotification *)notification {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNeedsDisplay];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.attributedPlaceholder) {
        CGRect placeholderRect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
        CGFloat padding = self.textContainer.lineFragmentPadding;
        placeholderRect.origin.x += padding;
        placeholderRect.size.width -= (2 * padding);
        [self.attributedPlaceholder drawInRect:placeholderRect];
    }
}

#pragma mark - Public Setters

- (void)setPlaceholder:(NSString *)placeholder {
    if ([placeholder isEqualToString:self.placeholder]) {
        return;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.typingAttributes];
    dictionary[NSFontAttributeName] = self.font ?: [UIFont systemFontOfSize:[UIFont systemFontSize]];
    dictionary[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor whiteColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    dictionary[NSParagraphStyleAttributeName] = paragraphStyle;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder.copy attributes:dictionary];
}

- (NSString *)placeholder {
    return self.attributedPlaceholder.string;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    if ([attributedPlaceholder isEqualToAttributedString:_attributedPlaceholder]) {
        return;
    }
    
    _attributedPlaceholder = attributedPlaceholder.copy;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if ([placeholderColor isEqual:_placeholderColor]) {
        return;
    }
    
    _placeholderColor = placeholderColor;
    NSMutableAttributedString *placeholder = self.attributedPlaceholder.mutableCopy;
    [placeholder addAttribute:NSForegroundColorAttributeName value:_placeholderColor range:NSMakeRange(0, placeholder.length)];
    self.attributedPlaceholder = placeholder;
}

@end