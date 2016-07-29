//
//  SBNotificationSettings.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/29/15.
//  Copyright (c) 2015 Fullscreen Direct. All rights reserved.
//

#import "SBObject.h"

@interface SBNotificationSettings :  MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *email;
@property (nonatomic) NSNumber *push;
@property (nonatomic) NSNumber *web;

@end
