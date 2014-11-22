//
//  SBOrder.h
//  Pods
//
//  Created by Josh Holat on 10/17/14.
//
//

#import "SBObject.h"

@class SBAddress;
@class SBAccount;
@class SBUser;
@interface SBOrder : SBObject <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *dateOrdered;
@property (nonatomic, strong) id dateShipped; // NSNumber (false) or NSDate
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *stripeChargeId;
@property (nonatomic, strong) NSNumber *totalUsd;

@property (nonatomic, strong) SBAddress *address;
@property (nonatomic, strong) id account; // SBAccount or NSNumber
@property (nonatomic, strong) id customer; // SBUser or NSNumber

@end
