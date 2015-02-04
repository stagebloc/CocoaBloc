//
// Created by John Heaton on 2/4/15.
// Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBPlaceholderTextView.h"


@implementation SBPlaceholderTextView {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;

    self.delegate = self;

    return self;
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView {
    if(![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
    else{
        placeholderLabel.hidden = YES;
    }
}

@end