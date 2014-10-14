//
//  SBStoreItem.m
//  CocoaBloc
//
//  Created by John Heaton on 10/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBStoreItem.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBStoreItemOption

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"height" 				: @"height",
             @"length" 				: @"length",
             @"width"				: @"width",
             @"lowStockThreshold" 	: @"low_stock_threshold",
             @"name"				: @"name",
             @"quantity"			: @"quantity",
             @"sku"					: @"sku",
             @"soldOut"				: @"sold_out",
             @"unlimited"			: @"unlimited",
             @"weightUnit"			: @"weight_unit",
             @"weight"				: @"weight",
             @"upc"					: @"upc"
    };
}

@end

@implementation SBStoreItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *map =
    @{
      @"postingAccountID" 	: @"account",
      @"category"			: @"category",
      @"creationDate"		: @"created",
      @"authorUserID"		: @"created_by",
      @"exclusive"			: @"exclusive",
      @"fansNamePrice"		: @"fans_name_price",
      @"featured"			: @"featured",
      @"descriptiveText"	: @"description",
      @"modificationDate"	: @"modified",
      @"modifyingAccountID"	: @"modified_by",
      @"onSale"				: @"on_sale",
      @"options"			: @"options",
      @"numberOfPhotos"		: @"photos",
      @"shortURL"			: @"short_url",
      @"photoID"			: @"photo",
      @"soldOut"			: @"sold_out",
      @"title"				: @"title",
      @"type"				: @"type"
    };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:map];
}

- (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

- (MTLValueTransformer *)modificationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

- (MTLValueTransformer *)shortURLJSONTransformer {
    return [MTLValueTransformer reversibleStringToURLTransformer];
}

- (MTLValueTransformer *)optionsJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *options) {
        return [MTLJSONAdapter modelsOfClass:[SBStoreItemOption class]
                               fromJSONArray:options
                                       error:nil];
    } reverseBlock:^id(NSArray *optionModels) {
        return [MTLJSONAdapter JSONArrayFromModels:optionModels];
    }];
}

@end
