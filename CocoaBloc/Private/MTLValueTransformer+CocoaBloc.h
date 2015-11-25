//
//  MTLValueTransformer+CocoaBloc.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Mantle/MTLValueTransformer.h>

@interface MTLValueTransformer (CocoaBloc)

+ (instancetype)reversibleStringToURLTransformer;
+ (instancetype)reversibleStringToDateTransformerWithFormatter:(NSDateFormatter *)dateFormatter;

// Models
+ (instancetype)reversibleModelJSONOnlyTransformer;
+ (instancetype)reversibleModelJSONOnlyTransformerForModelClass:(Class)modelClass; // only use if you need to

+ (instancetype)reversibleModelIDOnlyTransformer;

@end
