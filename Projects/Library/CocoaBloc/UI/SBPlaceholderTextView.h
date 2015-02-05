//
// Created by John Heaton on 2/4/15.
// Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBPlaceholderTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end