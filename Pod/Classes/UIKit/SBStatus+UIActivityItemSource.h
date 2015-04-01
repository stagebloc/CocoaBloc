//
//  SBStatus+UIActivityItemSource.h
//  CocoaBloc
//
//  Created by John Heaton on 1/30/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBStatus.h"

@import UIKit.UIActivityItemProvider;

@interface SBStatus (UIActivityItemSource) <UIActivityItemSource>

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController;
- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType;

@end
