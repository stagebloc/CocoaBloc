//
//  MTLValueTransformer+Convenience.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "MTLValueTransformer.h"

@interface MTLValueTransformer (Convenience)

+ (instancetype)reversibleStringToURLTransformer;
+ (instancetype)reversibleStringToDateTransformerWithFormatter:(NSDateFormatter *)dateFormatter;

@end
