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
#import "SBPhoto.h"
#import "SBUser.h"

@interface SBStoreItemPriceConfiguration : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *currency;
@property (nonatomic) NSNumber *price;

@end

@interface SBStoreItemOption : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *height;
@property (nonatomic) NSNumber *length;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *lowStockThreshold;
@property (nonatomic) NSNumber *quantity;
@property (nonatomic) NSNumber *soldOut;
@property (nonatomic) NSNumber *unlimited;
@property (nonatomic) NSNumber *weight;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *weightUnit;
@property (nonatomic, copy) NSString *upc;

@end

@interface SBStoreItem : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *category;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic, getter=isExclusive) NSNumber *exclusive;
@property (nonatomic) NSNumber *fansNamePrice;
@property (nonatomic, getter=isFeatured) NSNumber *featured;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSDate *modificationDate;
@property (nonatomic, getter=isOnSale) NSNumber *onSale;
@property (nonatomic) NSArray *options; // [SBStoreItemOptions]
@property (nonatomic) NSURL *shortURL;
@property (nonatomic) NSNumber *soldOut;
@property (nonatomic) NSArray *priceConfigurations;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSString *type;

@property (nonatomic) NSNumber *numberOfPhotos;

@property (nonatomic) SBUser *authorUser;
@property (nonatomic) SBAccount *postingAccount;
@property (nonatomic) SBUser *modifyingUser;
@property (nonatomic) NSArray *photos;
@property (nonatomic) SBPhoto *coverPhoto;

@property (nonatomic) NSNumber *authorUserID;
@property (nonatomic) NSNumber *postingAccountID;
@property (nonatomic) NSNumber *modifyingUserID;
@property (nonatomic) NSNumber *coverPhotoID;

- (RACSignal *)fetchAuthorUser;
- (RACSignal *)fetchPostingAccount;
- (RACSignal *)fetchModifyingUser;
- (RACSignal *)fetchCoverPhoto;

@end
