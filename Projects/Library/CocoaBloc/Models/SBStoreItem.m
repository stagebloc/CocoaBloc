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
@property (nonatomic) RACCommand *fetchAuthorUserCommand;
@property (nonatomic) RACCommand *fetchPostingAccountCommand;
@property (nonatomic) RACCommand *fetchModifyingUserCommand;
@property (nonatomic) RACCommand *fetchPhotosCommand;
@property (nonatomic) RACCommand *fetchCoverPhotoCommand;
@end

@implementation SBStoreItem

- (RACSignal *)fetchAuthorUser {
    return [self.fetchAuthorUserCommand execute:nil];
}

- (RACSignal *)fetchPostingAccount {
    return [self.fetchPostingAccountCommand execute:nil];
}

- (RACSignal *)fetchModifyingUser {
    return [self.fetchModifyingUserCommand execute:nil];
}

- (RACSignal *)fetchCoverPhoto {
    return [self.fetchCoverPhotoCommand execute:nil];
}

- (id)init {
    if ((self = [super init])) {
        @weakify(self);
        
        _fetchAuthorUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.authorUser != nil
            ? [RACSignal return:self.authorUser]
            : [[[SBClient new] getUserWithID:self.authorUserID]
                doNext:^(SBUser *user) {
                    self.authorUser = user;
                }];
        }];
        
        _fetchPostingAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.postingAccount != nil
            ? [RACSignal return:self.postingAccount]
            : [[[SBClient new] getAccountWithID:self.postingAccountID]
                doNext:^(SBAccount *account) {
                    self.postingAccount = account;
                }];
        }];
        
        _fetchModifyingUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.modifyingUser != nil
            ? [RACSignal return:self.modifyingUser]
            : [[[SBClient new] getUserWithID:self.modifyingUserID]
                doNext:^(SBUser *user) {
                    self.modifyingUser = user;
                }];
        }];
        
        _fetchCoverPhotoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SBClient *client) {
            @strongify(self);
            
            return self.coverPhoto != nil
            ? [RACSignal return:self.coverPhoto]
            : [[self.fetchPostingAccount
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
      @"coverPhotoID"       : @"photo",
      @"coverPhoto"         : @"photo",
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
      @"fetchAuthorUserCommand" : [NSNull null],
      @"fetchPostingAccountCommand" : [NSNull null],
      @"fetchModifyingUserCommand" : [NSNull null],
      @"fetchPhotosCommand" : [NSNull null],
      @"fetchCoverPhotoCommand" : [NSNull null],
      };
    
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
