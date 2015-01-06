//
//  SBNotification.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBNotification.h"
#import <MTLValueTransformer.h>
#import <NSDictionary+MTLManipulationAdditions.h>
#import "MTLValueTransformer+Convenience.h"
#import "NSDateFormatter+CocoaBloc.h"
#import "SBAccount.h"

@implementation SBNotification

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"creationDate"               : @"created",
              @"HTMLText"                   : @"html_message",
              @"text"                       : @"message",
              @"route"                      : @"route",
              @"accountOrAccountID"         : @"account"}];
}

+ (MTLValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatter]];
}

+ (MTLValueTransformer *)accountOrAccountIDJSONTransformer {
    return [MTLValueTransformer reversibleModelIDOrJSONTransformerForClass:[SBAccount class]];
}

@end
