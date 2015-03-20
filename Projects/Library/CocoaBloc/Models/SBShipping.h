//
//  SBShipping.h
//  CocoaBloc
//
//  Created by John Heaton on 2/25/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <SBObject.h>

@interface SBShippingMethod : SBObject

@property (nonatomic, copy) NSString *commitment;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSDecimalNumber *price;
@property (nonatomic) NSDecimalNumber *handlingPrice;

@end

@interface SBShippingPriceHandler : SBObject

@property (nonatomic) NSArray *shippingMethods;

@end

@interface SBShippingFulfiller : SBObject

@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSArray *priceHandlers;

@end

@interface SBShippingRate : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSArray *fulfillers;

@end

@interface SBShippingRateSet : MTLModel <MTLJSONSerializing>

@property (nonatomic) SBShippingRate *ordersRate;
@property (nonatomic) SBShippingRate *preOrdersRate;

@end
