//
//  UIApplication+Extension.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "UIApplication+Extension.h"

@implementation UIApplication (Extension)

+ (BOOL) canOpenSettings {
    return (&UIApplicationOpenSettingsURLString != NULL);
}

- (BOOL) openSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    return [self openURL:url];
}

@end
