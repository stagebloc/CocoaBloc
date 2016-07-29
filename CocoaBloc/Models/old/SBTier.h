//
//  SBTier.h
//  CocoaBloc
//
//  Created by Mark Glagola on 1/15/15.
//  Copyright (c) 2015 Fullscreen Direct. All rights reserved.
//

#import "SBObject.h"

@interface SBTier : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *canSubmitContent;
@property (nonatomic) NSNumber *discount;
@property (nonatomic) NSNumber *membershipLengthInterval;
@property (nonatomic) NSString *membershipLengthUnit;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *renewalPrice;

- (NSString *)readableLengthString;

@end