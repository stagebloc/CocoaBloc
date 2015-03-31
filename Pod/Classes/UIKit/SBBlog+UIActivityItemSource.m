//
//  SBBlog+UIActivityItemSource.m
//  CocoaBloc
//
//  Created by John Heaton on 1/30/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBBlog+UIActivityItemSource.h"
#import "SBDeleteActivity.h"
#import "SBFlagActivity.h"

@implementation SBBlog (UIActivityItemSource)

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:SBDeleteActivityType] || [activityType isEqualToString:SBFlagActivityType]) {
        return self;
    }
    
    return self.shortURL.absoluteString; //[(self.body.length > 0 ? self.body : self.excerpt) dataUsingEncoding:NSUTF8StringEncoding];
}

//- (NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
//    return (__bridge NSString *)kUTTypeHTML;
//}

@end
