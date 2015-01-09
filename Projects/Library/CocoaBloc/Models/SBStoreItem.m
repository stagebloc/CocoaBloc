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
#import <RACCommand.h>
#import <RACEXTScope.h>
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

@interface SBStoreItem ()
@property (nonatomic) RACCommand *fetchAuthorUser;
@property (nonatomic) RACCommand *fetchPostingAccount;
@property (nonatomic) RACCommand *fetchModifyingUser;
@property (nonatomic) RACCommand *fetchPhotos;
@property (nonatomic) RACCommand *fetchCoverPhoto;
@end

@implementation SBStoreItem

- (RACSignal *)getAuthorUser {
    return [self.fetchAuthorUser execute:nil];
}

- (RACSignal *)getPostingAccount {
    return [self.fetchPostingAccount execute:nil];
}

- (RACSignal *)getModifyingUser {
    return [self.fetchModifyingUser execute:nil];
}

- (RACSignal *)getCoverPhoto {
    return [self.fetchCoverPhoto execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAuthorUser = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.authorUser != nil
            ? [RACSignal return:self.authorUser]
            : [[[SBClient new] getUserWithID:self.authorUserID]
                doNext:^(SBUser *user) {
                    self.authorUser = user;
                }];
        }];
        
        _fetchPostingAccount = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.postingAccount != nil
            ? [RACSignal return:self.postingAccount]
            : [[[SBClient new] getAccountWithID:self.postingAccountID]
                doNext:^(SBAccount *account) {
                    self.postingAccount = account;
                }];
        }];
        
        _fetchModifyingUser = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.modifyingUser != nil
            ? [RACSignal return:self.modifyingUser]
            : [[[SBClient new] getUserWithID:self.modifyingUserID]
                doNext:^(SBUser *user) {
                    self.modifyingUser = user;
                }];
        }];
        
        _fetchCoverPhoto = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.coverPhoto != nil
            ? [RACSignal return:self.coverPhoto]
            : [[self.getPostingAccount
                    flattenMap:^RACStream *(SBAccount *account) {
                        return [[SBClient new] getPhotoWithID:self.coverPhotoID forAccount:account];
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
      @"authorUserID"		: @"created_by",
      @"authorUser"         : @"created_by",
      @"modifyingAccountID"	: @"modified_by",
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
      @"type"				: @"type"};
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:map];
}

+ (MTLValueTransformer *)numberOfPhotosJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOnlyTransformer]; // this works because it thinks it's an identifier
}

+ (MTLValueTransformer *)photosJSONTransformer {
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
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)priceConfigurationsJSONTransformer {
    return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
