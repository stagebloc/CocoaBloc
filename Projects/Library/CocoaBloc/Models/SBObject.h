//
//  SBObject.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *identifier;

@end
