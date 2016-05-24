//
//  SBStoreItem.m
//  CocoaBloc
//
//  Created by John Heaton on 10/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBStoreItem.h"
#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"
#import "SBUser.h"
#import "SBAccount.h"

@implementation SBStoreItemPriceConfiguration

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"currency" : @"currency",
			 @"price"	 : @"price"};
}

@end

@implementation SBStoreItemOption

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"height" 				: @"height",
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
			 @"disabled"			: @"disabled",
			 @"upc"					: @"upc"};
}

@end

@implementation SBStoreItem

- (NSDecimalNumber *)getPriceForCurrency:(NSString *)currency {
	NSNumber *price = nil;
	for (SBStoreItemPriceConfiguration *priceConfiguration in self.priceConfigurations) {
		if ([priceConfiguration.currency.lowercaseString isEqualToString:currency.lowercaseString]) {
			price = priceConfiguration.price;
			break;
		}
	}
	if (price == nil) {
		return nil;
	}
	
	if (self.onSale.boolValue) {
		if ([self.saleType isEqualToString:@"percent"]) {
			price = @(([price doubleValue] - (([self.saleAmountOrPercentage doubleValue] / 100.0) * [price doubleValue])));
		} else if ([self.saleType isEqualToString:@"amount"]) {
			price = @(([price doubleValue] - [self.saleAmountOrPercentage doubleValue]));
		}
	}
	return [NSDecimalNumber decimalNumberWithDecimal:price.decimalValue];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *map =
	@{@"postingAccountID" 	: @"account",
	  @"postingAccount"     : @"account",
	  @"coverPhotoID"       : @"photo",
	  @"coverPhoto"         : @"photo",
	  @"tags"               : @"tags",
	  @"authorUserID"		: @"created_by",
	  @"authorUser"         : @"created_by",
	  @"modifyingUserID"    : @"modified_by",
	  @"modifyingUser"      : @"modified_by",
	  @"numberOfPhotos"     : @"photos",
	  @"photos"				: @"photos",
	  @"category"			: @"category",
	  @"creationDate"		: @"created",
	  @"exclusive"			: @"exclusive",
	  @"fansNamePrice"		: @"fans_name_price",
	  @"featured"			: @"featured",
	  @"descriptiveText"	: @"description",
	  @"modificationDate"	: @"modified",
	  @"onSale"				: @"on_sale",
	  @"options"			: @"options",
	  @"priceConfigurations": @"prices",
	  @"shortURL"			: @"short_url",
	  @"soldOut"			: @"sold_out",
	  @"title"				: @"title",
	  @"type"				: @"type",
	  @"saleAmountOrPercentage"         : @"sale_amount",
	  @"saleType"           : @"sale_type",
	  @"saleEndDate"        : @"sale_end_date"};
	
	return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:map];
}

+ (MTLValueTransformer *)numberOfPhotosJSONTransformer {
	return [MTLValueTransformer transformerUsingReversibleBlock:^id(id photosObject, BOOL *success, NSError **error) {
		*success = YES;
		
		if ([photosObject isKindOfClass:[NSArray class]]) {
			return @([photosObject count]);
		}
		
		return photosObject;
	}];
}

+ (MTLValueTransformer *)saleEndDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)photosJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)coverPhotoIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)coverPhotoJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)authorUserJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)postingAccountIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)postingAccountJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)modifyingUserIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)modifyingUserJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)modificationDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)optionsJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBStoreItemOption class]];
}

+ (MTLValueTransformer *)priceConfigurationsJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformerForModelClass:[SBStoreItemPriceConfiguration class]];
}

@end
