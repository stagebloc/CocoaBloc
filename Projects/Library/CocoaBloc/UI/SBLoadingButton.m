//
//  SBLoadingButton.m
//  CocoaBloc
//
//  Created by Mark Glagola on 3/2/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBLoadingButton.h"
#import <PureLayout/PureLayout.h>
#import "UIFont+CocoaBloc.h"

@interface SBLoadingButton ()

@end

@implementation SBLoadingButton

+ (instancetype)buttonWithTitle:(NSString *)title {
    SBLoadingButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.spinner.hidesWhenStopped = YES;
        [self addSubview:self.spinner];
        [self.spinner autoCenterInSuperview];
        
        self.titleLabel.font = [UIFont fc_boldFontWithSize:17.0f];
    }
    return self;
}

- (BOOL)isLoading {
    return self.spinner.isAnimating;
}

- (void)startLoading {
    self.titleLabel.alpha = 0;
    self.enabled = NO;
    [self.spinner startAnimating];
}

- (void)stopLoading {
    self.titleLabel.alpha = 1;
    self.enabled = YES;
    [self.spinner stopAnimating];
}


@end

@implementation RACSignal (SBLoadingButton)

- (instancetype)rac_loadingButton:(SBLoadingButton *)loadingButton {
    @weakify(loadingButton);
    return [[self initially:^{
        @strongify(loadingButton);
        [loadingButton startLoading];
    }] finally:^{
        @strongify(loadingButton);
        [loadingButton stopLoading];
    }];
}

@end
