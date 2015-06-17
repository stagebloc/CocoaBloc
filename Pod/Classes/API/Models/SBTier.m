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
    
    NSString *unit = self.membershipLengthUnit;
    int interval = self.membershipLengthInterval.intValue;

    if ([unit isEqualToString:@"once"]) {
        return @"once";
    } else if ([unit isEqualToString:@"year"]) {
        return interval == 1 ? @"annually" : [NSString stringWithFormat:@"%d %@", interval, [unit stringByAppendingString:@"s"]];
    } else if ([unit isEqualToString:@"month"]) {
        return interval == 1 ? @"monthly" : [NSString stringWithFormat:@"%d %@", interval, [unit stringByAppendingString:@"s"]];
    } else if ([unit isEqualToString:@"day"]) {
        return interval == 1 ? @"daily" : [NSString stringWithFormat:@"%d %@", interval, [unit stringByAppendingString:@"s"]];
    } else {
        return [NSString stringWithFormat:@"%d %@", interval, unit];
    }
}

@end
