//
//  SBTier.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/15/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "SBTier.h"

@implementation SBTier

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"canSubmitContent"            : @"can_submit_content",
             @"title"                       : @"title",
             @"descriptiveText"             : @"description",
             @"discount"                    : @"discount",
             @"membershipLengthInterval" 	: @"membership_length_interval",
             @"membershipLengthUnit"        : @"membership_length_unit",
             @"price"                       : @"price",
             @"renewalPrice"                : @"renewal_price",
             };
}

- (NSString *)readableLengthString {
    NSString *(^format)(int, NSString *, NSString *) = ^(int value, NSString *singular, NSString *plural) {
        switch (value) {
            case 1: return [NSString stringWithFormat:@"%d %@", value, singular];
            default: return [NSString stringWithFormat:@"%d %@", value, plural];
        }
    };
    
    if ([self.membershipLengthUnit isEqualToString:@"year"]) {
        return format(self.membershipLengthInterval.intValue, @"year", @"year");
    }
    
    if ([self.membershipLengthUnit isEqualToString:@"month"]) {
        return format(self.membershipLengthInterval.intValue, @"month", @"months");
    }
    
    if ([self.membershipLengthUnit isEqualToString:@"day"]) {
        return format(self.membershipLengthInterval.intValue, @"day", @"days");
    }
    
    if ([self.membershipLengthUnit isEqualToString:@"once"]) {
        return @"once";
    }
    
    //unkown case
    return [NSString stringWithFormat:@"%d %@", self.membershipLengthInterval.intValue, self.membershipLengthUnit];
}

@end
