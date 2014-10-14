//
//  SBStoreItem.h
//  CocoaBloc
//
//  Created by John Heaton on 10/14/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBObject.h"
#import <Mantle/MTLJSONAdapter.h>
#import "SBAccount.h"

@interface SBStoreItemPriceConfiguration : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *currency;
@property (nonatomic) NSNumber *price;

@end

@interface SBStoreItemShippingProvider : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *price;

@end

@interface SBStoreItemOption : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *height;
@property (nonatomic) NSNumber *length;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *lowStockThreshold;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *quantity;
@property (nonatomic) NSString *sku;
@property (nonatomic) NSNumber *soldOut;
@property (nonatomic) NSNumber *unlimited;
@property (nonatomic) NSString *weightUnit;
@property (nonatomic) NSNumber *weight;
@property (nonatomic) NSString *upc;

@end

@interface SBStoreItem : SBObject <MTLJSONSerializing>

@property (nonatomic) NSNumber *postingAccountID;
@property (nonatomic, copy) NSString *category;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSNumber *authorUserID;
@property (nonatomic, getter=isExclusive) NSNumber *exclusive;
@property (nonatomic) NSNumber *fansNamePrice;
@property (nonatomic, getter=isFeatured) NSNumber *featured;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSDate *modificationDate;
@property (nonatomic) NSNumber *modifyingAccountID;
@property (nonatomic, getter=isOnSale) NSNumber *onSale;
@property (nonatomic) NSArray *options; // [SBStoreItemOptions]
@property (nonatomic) NSNumber *numberOfPhotos;
@property (nonatomic) NSNumber *photoID;
@property (nonatomic) NSURL *shortURL;
@property (nonatomic) NSNumber *soldOut;
@property (nonatomic) NSArray *priceConfigurations;
@property (nonatomic) NSArray *shippingProviders;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSString *type;

@end
