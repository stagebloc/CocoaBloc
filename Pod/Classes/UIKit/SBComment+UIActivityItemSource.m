//
//  SBComment+UIActivityItemSource.m
//  CocoaBloc
//
//  Created by John Heaton on 1/30/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBComment+UIActivityItemSource.h"
#import "SBDeleteActivity.h"
#import "SBFlagActivity.h"
#import "SBBanUserActivity.h"

@implementation SBComment (UIActivityItemSource)

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:SBDeleteActivityType] ||
        [activityType isEqualToString:SBFlagActivityType] ||
        [activityType isEqualToString:SBBanUserActivityType]) {
        return self;
    }
    return self.shortURL.absoluteString;
}

@end
