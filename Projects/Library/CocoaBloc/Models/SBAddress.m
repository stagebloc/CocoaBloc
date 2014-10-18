//
//  SBAddress.m
//  Pods
//
//  Created by Josh Holat on 10/18/14.
//
//

#import "SBAddress.h"
#import "MTLValueTransformer+Convenience.h"

@implementation SBAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier"			: @"id"};
}

@end
