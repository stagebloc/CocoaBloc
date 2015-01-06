//
//  UIApplication+Extension.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extension)

+ (BOOL) canOpenSettings;
- (BOOL) openSettings;

@end
