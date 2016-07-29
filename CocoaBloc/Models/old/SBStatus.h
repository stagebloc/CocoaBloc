//
//  SBStatus.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBStatus : SBContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSDate *publishDate;

@end

NS_ASSUME_NONNULL_END
