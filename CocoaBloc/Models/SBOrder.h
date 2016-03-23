//
//  SBOrder.h
//  Pods
//
//  Created by Josh Holat on 10/17/14.
//
//

#import "SBObject.h"

@class SBAddress, SBAccount, SBUser, SBClient, RACSignal;

@interface SBOrder : SBObject <MTLJSONSerializing>

@property (nonatomic) NSDate *dateOrdered;
@property (nonatomic) NSDate *dateShipped;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *stripeChargeId;
@property (nonatomic) NSNumber *totalUsd;

@property (nonatomic) SBAddress *address;

@property (nonatomic) NSNumber *accountID;
@property (nonatomic) NSNumber *customerUserID;

@property (nonatomic) SBAccount *account;
@property (nonatomic) SBUser *customerUser;

@end
