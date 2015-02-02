//
//  SBDeleteActivity.h
//  CocoaBloc
//
//  Created by John Heaton on 1/30/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBClient.h"

@interface SBDeleteActivity : UIActivity

- (instancetype)initWithClient:(SBClient *)client;

@end


extern NSString *const SBDeleteActivityType;