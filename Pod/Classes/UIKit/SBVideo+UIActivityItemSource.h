//
//  SBVideo+UIActivityItemSource.h
//  CocoaBloc
//
//  Created by John Heaton on 2/20/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBVideo.h"

@interface SBVideo (UIActivityItemSource) <UIActivityItemSource>

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController;
- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType;

@end
