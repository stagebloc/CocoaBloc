//
//  SBLoadingButton.h
//  CocoaBloc
//
//  Created by Mark Glagola on 3/2/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SBLoadingButton : UIButton

@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) UIActivityIndicatorView *spinner;

+ (instancetype)buttonWithTitle:(NSString *)title;

- (void)startLoading;
- (void)stopLoading;

@end


@interface RACSignal (SBLoadingButton)

/*!
 Observes initially and finally blocks to call
 `startLoading` and `stopLoading` accordingly
 */
- (instancetype)rac_loadingButton:(SBLoadingButton *)loadingButton;

@end