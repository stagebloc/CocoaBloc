    //
//  SBStoreItem.m
//  CocoaBloc
//
//  Created by John Heaton on 10/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBStoreItem.h"
#import "SBPhoto.h"
#import "MTLValueTransformer+Convenience.h"
#import <Mantle/NSDictionary+MTLManipulationAdditions.h>
#import "NSDateFormatter+CocoaBloc.h"
#import <ReactiveCocoa/RACCommand.h>
#import <ReactiveCocoa/RACExtScope.h>
#import "SBUser.h"
#import "SBAccount.h"
#import "SBClient+User.h"
#import "SBClient+Account.h"
#import "SBClient+Photo.h"

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
             @"upc"					: @"upc"};
}

@end

@implementation SBStoreItem {
    RACCommand *_fetchAuthorUserCommand;
    RACCommand *_fetchPostingAccountCommand;
    RACCommand *_fetchModifyingUserCommand;
    RACCommand *_fetchPhotosCommand;
    RACCommand *_fetchCoverPhotoCommand;
}

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

- (RACSignal *)fetchAuthorUser {
    return [self fetchAuthorUserWithClient:nil];
}

- (RACSignal *)fetchAuthorUserWithClient:(SBClient*)client {
    return [_fetchAuthorUserCommand execute:client];
}

- (RACSignal *)fetchPostingAccount {
    return [self fetchPostingAccountWithClient:nil];
}

- (RACSignal *)fetchPostingAccountWithClient:(SBClient*)client {
    return [_fetchPostingAccountCommand execute:client];
}

- (RACSignal *)fetchModifyingUser {
    return [self fetchModifyingUserWithClient:nil];
}

- (RACSignal *)fetchModifyingUserWithClient:(SBClient*)client {
    return [_fetchModifyingUserCommand execute:client];
}

- (RACSignal *)fetchCoverPhoto {
    return [self fetchCoverPhotoWithClient:nil];
}

- (RACSignal *)fetchCoverPhotoWithClient:(SBClient*)client {
    return [_fetchCoverPhotoCommand execute:client];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAuthorUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];
            
            return self.authorUser != nil
            ? [RACSignal return:self.authorUser]
            : [[client getUserWithID:self.authorUserID]
                doNext:^(SBUser *user) {
                    self.authorUser = user;
                }];
        }];
        
        _fetchPostingAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            client = client ?: [SBClient new];
            
            return self.postingAccount != nil
            ? [RACSignal return:self.postingAccount]
            : [[client getAccountWithID:self.postingAccountID]
                doNext:^(SBAccount *account) {
                    self.postingAccount = account;
                }];
        }];
        
        _fetchModifyingUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);

            client = client ?: [SBClient new];

            return self.modifyingUser != nil
            ? [RACSignal return:self.modifyingUser]
            : [[client getUserWithID:self.modifyingUserID]
                doNext:^(SBUser *user) {
                    self.modifyingUser = user;
                }];
        }];
        
        _fetchCoverPhotoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);

            client = client ?: [SBClient new];

            return self.coverPhoto != nil
            ? [RACSignal return:self.coverPhoto]
            : [[self.fetchPostingAccount
                    flattenMap:^RACStream *(SBAccount *account) {
                        return [client getPhotoWithID:self.coverPhotoID forAccount:account];
                    }]
                    doNext:^(SBPhoto *photo) {
                        self.coverPhoto = photo;
                    }];
        }];
    }
    return self;
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
    return [MTLValueTransformer reversibleTransformerWithBlock:^id(id photosObject) {
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
