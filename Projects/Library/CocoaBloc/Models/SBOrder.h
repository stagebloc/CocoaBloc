//
//  SBOrder.h
//  Pods
//
//  Created by Josh Holat on 10/17/14.
//
//

#import "SBObject.h"

@interface SBOrder : SBObject <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *dateOrdered;
@property (nonatomic, strong) NSNumber *totalUsd;

@end
