//
//  SBAddress.h
//  Pods
//
//  Created by Josh Holat on 10/18/14.
//
//

#import "SBObject.h"

@interface SBAddress : SBObject <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *streetAddressTwo;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *stateProvince;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *country;

@end
