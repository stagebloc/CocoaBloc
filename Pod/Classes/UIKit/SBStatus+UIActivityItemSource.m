//
//  SBStatus+UIActivityItemSource.m
//  CocoaBloc
//
//  Created by John Heaton on 1/30/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBStatus+UIActivityItemSource.h"
#import "SBDeleteActivity.h"
#import "SBFlagActivity.h"

@implementation SBStatus (UIActivityItemSource)

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:SBDeleteActivityType] || [activityType isEqualToString:SBFlagActivityType]) {
        return self;
    }
    
    return self.shortURL.absoluteString;
}

@end
