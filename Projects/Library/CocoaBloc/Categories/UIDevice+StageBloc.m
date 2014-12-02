//
//  UIDevice+StageBloc.m
//  StitchCam
//
//  Created by David Skuza on 10/8/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "UIDevice+StageBloc.h"

@implementation UIDevice (StageBloc)

- (BOOL)isAtLeastiOS:(NSInteger)version {
    return [[self systemVersion] integerValue] >= version;
}

@end
